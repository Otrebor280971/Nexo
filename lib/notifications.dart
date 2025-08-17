import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:nexo/inspect.dart'; // Tu servicio Gemini
import 'package:nexo/device_id_generator.dart'; // Tu generador de token
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final GeminiService _geminiService = GeminiService();
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Canal para comunicación con código nativo Android
  static const MethodChannel _channel = MethodChannel('notification_listener');
  
  bool _isListening = false;
  bool _isDeviceVerified = false;
  bool _serverRunning = false;
  String? _deviceToken;
  Process? _serverProcess;
  
  // URL del servidor local
  static const String _baseUrl = 'http://localhost:5000';
  
  // Callback para redirigir al login
  Function(String)? onDeviceNotVerified;

  /// Inicializa el servicio
  Future<void> initialize({Function(String)? onNotVerified}) async {
    onDeviceNotVerified = onNotVerified;
    await _initLocalNotifications();
    await _startLocalServer();
    _setupNotificationHandler();
  }

  /// Inicia el servidor Node.js local
  Future<void> _startLocalServer() async {
    try {
      // Verificar si Node.js está disponible
      ProcessResult nodeCheck = await Process.run('node', ['--version']);
      print('📦 Node.js detectado: ${nodeCheck.stdout.toString().trim()}');

      // Obtener la ruta del directorio de la app
      Directory appDir = await getApplicationDocumentsDirectory();
      String backendPath = '${appDir.parent.path}/Backend';
      
      print('🔍 Buscando servidor en: $backendPath');
      
      // Verificar si existe el archivo server.js
      File serverFile = File('$backendPath/server.js');
      if (!await serverFile.exists()) {
        // Si no existe, copiar desde assets
        await _copyBackendFromAssets(backendPath);
      }

      // Cambiar al directorio del backend
      Directory backendDir = Directory(backendPath);
      if (!await backendDir.exists()) {
        print('❌ Directorio Backend no encontrado');
        return;
      }

      // Instalar dependencias si no existen node_modules
      Directory nodeModules = Directory('$backendPath/node_modules');
      if (!await nodeModules.exists()) {
        print('📥 Instalando dependencias npm...');
        ProcessResult npmInstall = await Process.run(
          'npm', 
          ['install'], 
          workingDirectory: backendPath
        );
        print('npm install: ${npmInstall.stdout}');
        if (npmInstall.exitCode != 0) {
          print('❌ Error instalando dependencias: ${npmInstall.stderr}');
          return;
        }
      }

      // Verificar si el servidor ya está corriendo
      if (await _isServerRunning()) {
        print('✅ Servidor ya está corriendo en $_baseUrl');
        _serverRunning = true;
        return;
      }

      // Iniciar el servidor Node.js
      print('🚀 Iniciando servidor Node.js...');
      _serverProcess = await Process.start(
        'node', 
        ['server.js'],
        workingDirectory: backendPath,
        mode: ProcessStartMode.detached,
      );

      // Escuchar salida del servidor
      _serverProcess?.stdout.transform(utf8.decoder).listen((data) {
        print('🖥️ Server: $data');
        if (data.contains('Servidor corriendo')) {
          _serverRunning = true;
        }
      });

      _serverProcess?.stderr.transform(utf8.decoder).listen((data) {
        print('❌ Server Error: $data');
      });

      // Esperar a que el servidor inicie
      await Future.delayed(Duration(seconds: 3));
      
      if (await _isServerRunning()) {
        print('✅ Servidor iniciado exitosamente');
        _serverRunning = true;
      } else {
        print('❌ Error iniciando servidor');
      }

    } catch (e) {
      print('❌ Error configurando servidor local: $e');
    }
  }

  /// Verifica si el servidor está corriendo
  Future<bool> _isServerRunning() async {
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
      ).timeout(Duration(seconds: 2));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  /// Copia el backend desde assets (para distribución)
  Future<void> _copyBackendFromAssets(String backendPath) async {
    try {
      Directory backendDir = Directory(backendPath);
      if (!await backendDir.exists()) {
        await backendDir.create(recursive: true);
      }

      // Copiar server.js
      String serverJs = await rootBundle.loadString('assets/backend/server.js');
      await File('$backendPath/server.js').writeAsString(serverJs);

      // Copiar package.json
      String packageJson = await rootBundle.loadString('assets/backend/package.json');
      await File('$backendPath/package.json').writeAsString(packageJson);

      // Copiar .env
      String envFile = await rootBundle.loadString('assets/backend/.env');
      await File('$backendPath/.env').writeAsString(envFile);

      print('✅ Backend copiado desde assets');
    } catch (e) {
      print('❌ Error copiando backend: $e');
    }
  }

  /// Configuración básica de notificaciones locales
  Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _localNotifications.initialize(settings);
  }

  /// Configura el handler para recibir notificaciones del sistema
  void _setupNotificationHandler() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onNotificationReceived') {
        final String text = call.arguments['text'] ?? '';
        final String packageName = call.arguments['packageName'] ?? '';
        
        if (text.isNotEmpty) {
          await _processNotification(text, packageName);
        }
      }
    });
  }

  /// Verifica el token del dispositivo con MongoDB Atlas
  Future<bool> _verifyDeviceToken() async {
    try {
      if (!_serverRunning) {
        print('❌ Servidor local no está corriendo');
        // Intentar reiniciar el servidor
        await _startLocalServer();
        if (!_serverRunning) {
          if (onDeviceNotVerified != null) {
            onDeviceNotVerified!('Error de servidor. Reinicia la aplicación.');
          }
          return false;
        }
      }

      // Obtener el token del dispositivo
      _deviceToken = await DeviceIdHelper.getToken();
      
      if (_deviceToken == null || _deviceToken!.isEmpty) {
        print('❌ No se pudo generar token del dispositivo');
        return false;
      }

      print('🔍 Verificando token: $_deviceToken');

      // Llamada a tu API local para verificar en MongoDB
      final response = await http.post(
        Uri.parse('$_baseUrl/api/childDevices/verify'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'deviceToken': _deviceToken,
        }),
      ).timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        if (data['isVerified'] == true) {
          _isDeviceVerified = true;
          print('✅ Dispositivo correctamente vinculado');
          print('📋 Info: ${data['deviceInfo'] ?? 'Sin info adicional'}');
          
          // Mostrar notificación de confirmación
          await _showVerificationSuccess();
          return true;
        } else {
          _isDeviceVerified = false;
          print('❌ Dispositivo no vinculado a una cuenta');
          
          // Trigger callback para redirigir al login
          if (onDeviceNotVerified != null) {
            onDeviceNotVerified!('Dispositivo no vinculado. Inicia sesión para continuar.');
          }
          return false;
        }
      } else if (response.statusCode == 404) {
        _isDeviceVerified = false;
        print('❌ Dispositivo no encontrado en la base de datos');
        
        if (onDeviceNotVerified != null) {
          onDeviceNotVerified!('Dispositivo no registrado. Regístrate primero.');
        }
        return false;
      } else {
        print('❌ Error del servidor: ${response.statusCode} - ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Error verificando token: $e');
      
      // En caso de error de conexión
      if (onDeviceNotVerified != null) {
        onDeviceNotVerified!('Error de conexión con el servidor local. Verifica la configuración.');
      }
      return false;
    }
  }

  /// Muestra notificación de verificación exitosa
  Future<void> _showVerificationSuccess() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'device_verification',
      'Verificación de Dispositivo',
      channelDescription: 'Confirmación de vinculación del dispositivo',
      importance: Importance.high,
      priority: Priority.high,
      color: Colors.green,
      autoCancel: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      999, // ID fijo para esta notificación
      '✅ Nexo Activo',
      'Dispositivo correctamente vinculado. Protección iniciada.',
      details,
    );
  }

  /// Procesa la notificación recibida (solo si el dispositivo está verificado)
  Future<void> _processNotification(String text, String packageName) async {
    try {
      // Verificar si el dispositivo está autorizado antes de analizar
      if (!_isDeviceVerified) {
        print('⚠️ Dispositivo no verificado, omitiendo análisis');
        return;
      }

      print('📱 Nueva notificación de $packageName: $text');
      
      // Filtrar solo apps de mensajería relevantes
      if (_isRelevantApp(packageName)) {
        // Analizar con Gemini
        String resultado = await _geminiService.analizarMensaje(text);
        
        print('🔍 Resultado análisis: $resultado');
        
        // Si contiene "Negativo", mostrar alerta
        if (resultado.toLowerCase().contains('negativo')) {
          await _showAlert(resultado, text, packageName);
        }
      }
    } catch (e) {
      print('❌ Error procesando notificación: $e');
    }
  }

  /// Verifica si la app es relevante para monitoreo
  bool _isRelevantApp(String packageName) {
    List<String> appsRelevantes = [
      'whatsapp',
      'telegram',
      'messenger',
      'instagram',
      'snapchat',
      'discord',
      'mms', // SMS
      'messaging'
    ];
    
    return appsRelevantes.any((app) => 
        packageName.toLowerCase().contains(app));
  }

  /// Muestra alerta de seguridad
  Future<void> _showAlert(String analisis, String textoOriginal, String app) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'security_alerts',
      'Alertas de Seguridad Nexo',
      channelDescription: 'Detecta contenido potencialmente peligroso',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.red,
      autoCancel: false,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    String appName = _getAppName(app);
    String titulo = '🚨 ALERTA NEXO';
    String mensaje = 'Contenido sospechoso detectado en $appName';

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      titulo,
      mensaje,
      details,
    );

    print('🚨 ALERTA MOSTRADA: $titulo - $mensaje');
  }

  /// Convierte package name a nombre legible
  String _getAppName(String packageName) {
    if (packageName.contains('whatsapp')) return 'WhatsApp';
    if (packageName.contains('telegram')) return 'Telegram';
    if (packageName.contains('messenger')) return 'Messenger';
    if (packageName.contains('instagram')) return 'Instagram';
    if (packageName.contains('snapchat')) return 'Snapchat';
    if (packageName.contains('discord')) return 'Discord';
    if (packageName.contains('mms') || packageName.contains('messaging')) return 'SMS';
    return 'App de Mensajería';
  }

  /// Inicia el monitoreo de notificaciones (con verificación previa)
  Future<bool> startListening() async {
    try {
      if (_isListening) {
        print('✅ Ya está escuchando notificaciones');
        return true;
      }

      // PASO 1: Verificar que el servidor esté corriendo
      if (!_serverRunning) {
        print('🔄 Iniciando servidor local...');
        await _startLocalServer();
      }

      // PASO 2: Verificar token del dispositivo
      print('🔐 Verificando dispositivo...');
      bool isVerified = await _verifyDeviceToken();
      
      if (!isVerified) {
        print('❌ No se puede iniciar monitoreo - Dispositivo no verificado');
        return false;
      }

      // PASO 3: Verificar si el canal nativo está disponible
      bool hasNativeSupport = false;
      try {
        hasNativeSupport = await _channel.invokeMethod('isAvailable') ?? false;
      } catch (e) {
        print('⚠️ Código nativo no disponible, usando modo demo');
        return _startDemoMode();
      }

      if (hasNativeSupport) {
        // Solicitar permisos
        bool hasPermission = await _channel.invokeMethod('checkPermission') ?? false;
        
        if (!hasPermission) {
          print('❌ Sin permisos de notificaciones');
          await _channel.invokeMethod('openSettings');
          return false;
        }

        // Iniciar escucha
        bool started = await _channel.invokeMethod('startListening') ?? false;
        
        if (started) {
          _isListening = true;
          print('🎯 Escucha de notificaciones iniciada - Dispositivo verificado');
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('❌ Error iniciando servicio: $e');
      return _startDemoMode();
    }
  }

  /// Modo demo para testing sin código nativo (solo si está verificado)
  bool _startDemoMode() {
    if (!_isDeviceVerified) {
      print('❌ No se puede iniciar modo demo - Dispositivo no verificado');
      return false;
    }

    print('🧪 Iniciando modo DEMO - Dispositivo verificado');
    _isListening = true;
    
    // Simular notificaciones para testing
    Timer.periodic(Duration(seconds: 30), (timer) {
      if (!_isListening) {
        timer.cancel();
        return;
      }
      
      List<String> mensajesPrueba = [
        "Hola, ¿cómo estás?",
        "¿Quieres que nos veamos?",
        "No le digas a tus papás sobre esto",
        "Te puedo dar un regalo si vienes",
        "¿Me mandas una foto tuya?",
      ];
      
      String mensajePrueba = mensajesPrueba[DateTime.now().second % mensajesPrueba.length];
      _processNotification(mensajePrueba, 'com.whatsapp.demo');
    });
    
    return true;
  }

  /// Detiene el monitoreo y servidor
  Future<void> stopListening() async {
    try {
      if (!_isListening) return;
      
      await _channel.invokeMethod('stopListening');
      _isListening = false;
      _isDeviceVerified = false; // Reset verification
      
      // Detener servidor si está corriendo
      if (_serverProcess != null) {
        _serverProcess!.kill();
        _serverProcess = null;
        _serverRunning = false;
        print('🛑 Servidor Node.js detenido');
      }
      
      print('🛑 Monitoreo detenido');
    } catch (e) {
      print('Error deteniendo: $e');
      _isListening = false;
      _isDeviceVerified = false;
      _serverRunning = false;
    }
  }

  /// Fuerza re-verificación del dispositivo
  Future<bool> reVerifyDevice() async {
    _isDeviceVerified = false;
    return await _verifyDeviceToken();
  }

  /// Getters para estado
  bool get isListening => _isListening;
  bool get isDeviceVerified => _isDeviceVerified;
  bool get serverRunning => _serverRunning;
  String? get deviceToken => _deviceToken;
}