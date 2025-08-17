
// homepage.dart
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert'; // <- AGREGAR ESTA IMPORTACIÓN
import 'privacy_ethics.dart'; // Importar la pantalla de privacidad y ética
import 'education_resources.dart'; // Importar la pantalla de educación
import 'package:nexo/api_service.dart';


class ParentHomePage extends StatefulWidget {
  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  // Lista de dispositivos conectados
  List<Device> connectedDevices = [];

  // Lista de alertas de mensajes sospechosos
  List<SuspiciousAlert> suspiciousAlerts = [];

  // Variable para controlar si se han aceptado los términos de privacidad
  bool privacyTermsAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010324),
              Color(0xFF1a1b4b),
              Color(0xFF2d2e6b),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con flecha de regreso
              _buildHeader(),
              
              // Contenido principal con scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sección de privacidad y ética (si no se han aceptado los términos)
                      if (!privacyTermsAccepted) ...[
                        _buildPrivacyEthicsSection(),
                        SizedBox(height: 30),
                      ],
                      
                      // Sección de dispositivos
                      _buildDevicesSection(),
                      SizedBox(height: 30),
                      
                      // Sección de alertas
                      _buildAlertsSection(),
                      SizedBox(height: 30),
                      
                      // Sección de educación y recursos
                      _buildEducationSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          // Flecha para regresar
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context, 
                '/parent-login', 
                (route) => false
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          SizedBox(width: 16),
          
          // Título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Panel de control',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Supervisión parental',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          
          // Botón de configuración de privacidad (siempre visible)
          GestureDetector(
            onTap: () => _navigateToPrivacyEthics(),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: privacyTermsAccepted 
                  ? Colors.green.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                privacyTermsAccepted ? Icons.verified_user : Icons.security,
                color: privacyTermsAccepted ? Colors.green : Colors.orange,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyEthicsSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.security, color: Colors.orange, size: 28),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuración requerida',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Privacidad y ética',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Antes de agregar dispositivos, es necesario revisar y aceptar nuestros compromisos de privacidad y uso ético.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              height: 1.4,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _navigateToPrivacyEthics(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Configurar ahora',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDevicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Dispositivos conectados',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: privacyTermsAccepted 
                ? () => _showAddDeviceDialog()
                : () => _showPrivacyRequiredDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: privacyTermsAccepted 
                    ? Color(0xFF535BB0)
                    : Colors.grey.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      privacyTermsAccepted ? Icons.add : Icons.lock,
                      color: Colors.white,
                      size: 16,
                    ),
                    SizedBox(width: 4),
                    Text(
                      privacyTermsAccepted ? 'Agregar' : 'Bloqueado',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        
        // Lista de dispositivos o mensaje vacío
        if (connectedDevices.isNotEmpty)
          ...connectedDevices.map((device) => _buildDeviceCard(device)).toList()
        else
          _buildEmptyDevicesCard(),
      ],
    );
  }

  Widget _buildDeviceCard(Device device) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono del dispositivo
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              Icons.phone_android,
              color: Color(0xFF4CAF50),
              size: 24,
            ),
          ),
          SizedBox(width: 15),
          
          // Información del dispositivo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2d2e6b),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Conectado',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Botón de eliminar
          GestureDetector(
            onTap: () => _removeDevice(device),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Color(0xFFF44336),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDevicesCard() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.devices,
              color: Colors.white54,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'No hay dispositivos conectados',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              privacyTermsAccepted 
                ? 'Agrega el primer dispositivo de tu hijo'
                : 'Configura primero la privacidad y ética',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mensajes / alertas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        
        // Lista de alertas o mensaje vacío
        if (suspiciousAlerts.isNotEmpty)
          ...suspiciousAlerts.map((alert) => _buildAlertCard(alert)).toList()
        else
          _buildEmptyAlertsCard(),
      ],
    );
  }

  Widget _buildAlertCard(SuspiciousAlert alert) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de alerta
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFFF9800).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.warning,
              color: Color(0xFFFF9800),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          
          // Contenido de la alerta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mensaje sospechoso detectado',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2d2e6b),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${alert.deviceName} • ${_formatDateTime(alert.timestamp)}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAlertsCard() {
    return Container(
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white24),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: Color(0xFF4CAF50),
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              'No hay alertas por ahora',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Todo está funcionando correctamente',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Función para formatear fecha y hora
  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final alertDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (alertDate == today) {
      return 'Hoy ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (alertDate == today.subtract(Duration(days: 1))) {
      return 'Ayer ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  // Función para navegar a la pantalla de privacidad y ética
  void _navigateToPrivacyEthics() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PrivacyEthicsScreen(),
      ),
    );
    
    // Si el usuario completó la configuración de privacidad
    if (result == true) {
      setState(() {
        privacyTermsAccepted = true;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Ahora puedes agregar dispositivos de forma segura!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Diálogo que se muestra cuando se intenta agregar un dispositivo sin aceptar términos
  void _showPrivacyRequiredDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.security, color: Colors.orange),
            SizedBox(width: 8),
            Text('Configuración requerida'),
          ],
        ),
        content: Text(
          'Para agregar dispositivos, primero debes revisar y aceptar nuestros compromisos de privacidad y uso ético.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              Navigator.pop(context);
              _navigateToPrivacyEthics();
            },
            child: Text('Configurar ahora', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Diálogo para agregar dispositivo
  void _showAddDeviceDialog() {
    final _codeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Agregar Dispositivo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Ingresa el código que generó tu hijo:'),
            SizedBox(height: 15),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'Código de 8 dígitos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.qr_code),
              ),
              keyboardType: TextInputType.text,
              maxLength: 8,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF535BB0),
            ),
            onPressed: () {
              if (_codeController.text.length == 8) {
                _addDevice(_codeController.text);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ingresa un código válido de 8 dígitos'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: Text('Conectar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Función para agregar dispositivo
  void _addDevice(String code) async {
  // 1. Mostrar indicador de carga
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 15),
            Text('Conectando dispositivo...'),
          ],
        ),
      ),
    ),
  );

  try {
    // 2. Obtener el parentId del almacenamiento seguro
    const storage = FlutterSecureStorage();
    String? parentId = await storage.read(key: 'userId');

    if (parentId == null) {
      Navigator.pop(context); // Cerrar indicador de carga
      _showErrorSnackBar('Error: No se encontró el ID de usuario. Vuelve a iniciar sesión.');
      return;
    }

    // 3. Validar que el código tenga el formato correcto
    if (code.length != 8 || !RegExp(r'^\d+$').hasMatch(code)) {
      Navigator.pop(context); // Cerrar indicador de carga
      _showErrorSnackBar('El código debe tener exactamente 8 dígitos.');
      return;
    }

    // 4. Realizar la llamada a la API
    print('Intentando registrar dispositivo con código: $code para padre: $parentId');
    
    bool success = await registerDevice(code, parentId, 'Dispositivo de mi hijo');
    
    Navigator.pop(context); // Cerrar indicador de carga

    // 5. Manejar el resultado de la llamada
    if (success) {
      // Si fue exitoso, actualiza el estado de la UI
      setState(() {
        connectedDevices.add(Device(
          id: code,
          name: 'Dispositivo $code',
        ));
      });
      
      _showSuccessSnackBar('¡Dispositivo conectado exitosamente!');
      
      // Opcional: Guardar la lista actualizada en almacenamiento local
      await _saveDevicesList();
      
    } else {
      _showErrorSnackBar('Error: Código inválido o dispositivo ya registrado.');
    }
    
  } catch (e) {
    Navigator.pop(context); // Cerrar indicador de carga
    print('Error al conectar dispositivo: $e');
    _showErrorSnackBar('Error de conexión. Verifica tu internet e intenta de nuevo.');
  }
}

// Funciones auxiliares para mostrar mensajes
void _showSuccessSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
    ),
  );
}

void _showErrorSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(Icons.error, color: Colors.white),
          SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 4),
    ),
  );
}

// Función para guardar la lista de dispositivos localmente (opcional)
Future<void> _saveDevicesList() async {
  const storage = FlutterSecureStorage();
  List<Map<String, String>> devicesList = connectedDevices
      .map((device) => {'id': device.id, 'name': device.name})
      .toList();
  
  await storage.write(
    key: 'connected_devices',
    value: jsonEncode(devicesList),
  );
}

// Función para cargar dispositivos guardados al iniciar (agregar al initState)
Future<void> _loadSavedDevices() async {
  const storage = FlutterSecureStorage();
  String? devicesJson = await storage.read(key: 'connected_devices');
  
  if (devicesJson != null) {
    try {
      List<dynamic> devicesList = jsonDecode(devicesJson);
      setState(() {
        connectedDevices = devicesList
            .map((device) => Device(
                  id: device['id'] ?? '',
                  name: device['name'] ?? 'Dispositivo desconocido',
                ))
            .toList();
      });
    } catch (e) {
      print('Error al cargar dispositivos guardados: $e');
    }
  }
}

  // Función para eliminar dispositivo
  void _removeDevice(Device device) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Dispositivo'),
        content: Text('¿Estás seguro de que quieres desconectar "${device.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                connectedDevices.remove(device);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Dispositivo desconectado'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            child: Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Sección de educación y recursos
  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Educación y recursos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 15),
        
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF535BB0).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.school, color: Color(0xFF2196F3), size: 28),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aprende a proteger mejor',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2d2e6b),
                          ),
                        ),
                        Text(
                          'Guías y consejos para padres',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                'Accede a recursos educativos sobre ciberacoso, grooming, contenido inapropiado y más. Aprende qué hacer en situaciones de riesgo.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  height: 1.4,
                ),
              ),
              SizedBox(height: 15),
              
              // Quick tips preview
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Color(0xFF2196F3).withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline, color: Color(0xFF2196F3), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'Consejo rápido:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2196F3),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Habla regularmente con tu hijo/a sobre sus actividades digitales sin juzgar, creando un espacio seguro para compartir.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF495057),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _navigateToEducationResources(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Ver recursos educativos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Función para navegar a recursos educativos
  void _navigateToEducationResources() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EducationResourcesScreen(),
      ),
    );
  }
}

// Modelos de datos simplificados
class Device {
  final String id;
  final String name;

  Device({
    required this.id,
    required this.name,
  });
}

class SuspiciousAlert {
  final String id;
  final String deviceName;
  final DateTime timestamp;

  SuspiciousAlert({
    required this.id,
    required this.deviceName,
    required this.timestamp,
  });
}