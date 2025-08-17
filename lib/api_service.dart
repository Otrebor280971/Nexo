import 'package:http/http.dart' as http;
import 'dart:convert';

Future<String> login(String email, String password) async {
  final url = Uri.parse("http://10.50.87.211:5000/api/users/login");

  try {
    print('Intentando login con: $email');

    final response = await http.post(
      url, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({
        "email": email,
        "password": password  // Enviar password en texto plano, no passwordHash
      }),
    ).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Timeout: El servidor no respondió a tiempo');
      },
    );

    print('Código de respuesta: ${response.statusCode}');
    print('Cuerpo de respuesta: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final String userId = responseData['id'];
      print('Login exitoso, userId: $userId');
      return userId;
    } else {
      // Manejar diferentes tipos de errores
      final errorData = json.decode(response.body);
      final String errorMessage = errorData['error'] ?? 'Error desconocido';
      
      if (response.statusCode == 404) {
        throw Exception('Usuario no encontrado');
      } else if (response.statusCode == 401) {
        throw Exception('Contraseña incorrecta');
      } else if (response.statusCode == 400) {
        throw Exception('Datos inválidos: $errorMessage');
      } else {
        throw Exception('Error del servidor: $errorMessage');
      }
    }
  } catch (e) {
    print('Error en login: $e');
    
    if (e.toString().contains('SocketException') || 
        e.toString().contains('HandshakeException')) {
      throw Exception('Error de conexión: Verifica tu internet');
    } else if (e.toString().contains('TimeoutException') ||
               e.toString().contains('Timeout')) {
      throw Exception('Timeout: El servidor tardó demasiado en responder');
    } else if (e.toString().startsWith('Exception:')) {
      // Re-lanzar excepciones específicas ya manejadas
      rethrow;
    } else {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }
}

Future<bool> signup(String email, String password) async {
  final url = Uri.parse("http://10.50.87.211:5000/api/users/signup");

  try {
    print('Intentando registro con: $email');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    ).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Timeout: El servidor no respondió a tiempo');
      },
    );

    print('Código de respuesta signup: ${response.statusCode}');
    print('Cuerpo de respuesta signup: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else {
      final errorData = json.decode(response.body);
      final String errorMessage = errorData['error'] ?? 'Error desconocido';
      
      if (response.statusCode == 400) {
        throw Exception('El usuario ya existe o datos inválidos');
      } else {
        throw Exception('Error al crear cuenta: $errorMessage');
      }
    }
  } catch (e) {
    print('Error en signup: $e');
    
    if (e.toString().contains('SocketException') || 
        e.toString().contains('HandshakeException')) {
      throw Exception('Error de conexión: Verifica tu internet');
    } else if (e.toString().contains('TimeoutException') ||
               e.toString().contains('Timeout')) {
      throw Exception('Timeout: El servidor tardó demasiado en responder');
    } else if (e.toString().startsWith('Exception:')) {
      rethrow;
    } else {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }
}

// Función mejorada para registrar dispositivo
Future<bool> registerDevice(String token, String parentId, String alias) async {
  final url = Uri.parse("http://10.50.87.211:5000/api/childDevices/");

  try {
    print('Enviando solicitud a: $url');
    print('Datos: code=$token, parentId=$parentId, alias=$alias');

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "code": token,
        "parentId": parentId,
        "alias": alias
      }),
    ).timeout(
      Duration(seconds: 10),
      onTimeout: () {
        throw Exception('Timeout: El servidor no respondió a tiempo');
      },
    );

    print('Código de respuesta: ${response.statusCode}');
    print('Cuerpo de respuesta: ${response.body}');

    if (response.statusCode == 201) {
      return true;
    } else if (response.statusCode == 400) {
      print('Error 400: Código inválido o ya registrado');
      return false;
    } else if (response.statusCode == 404) {
      print('Error 404: Padre no encontrado');
      return false;
    } else if (response.statusCode >= 500) {
      print('Error del servidor: ${response.statusCode}');
      throw Exception('Error del servidor');
    } else {
      print('Error desconocido: ${response.statusCode}');
      return false;
    }

  } catch (e) {
    print('Excepción en registerDevice: $e');
    
    if (e.toString().contains('SocketException') || 
        e.toString().contains('HandshakeException')) {
      throw Exception('Error de conexión: Verifica tu internet');
    } else if (e.toString().contains('TimeoutException') ||
               e.toString().contains('Timeout')) {
      throw Exception('Timeout: El servidor tardó demasiado en responder');
    } else {
      throw Exception('Error inesperado: ${e.toString()}');
    }
  }
}

// Función adicional para verificar conectividad
Future<bool> checkServerConnectivity() async {
  try {
    final url = Uri.parse("http://10.50.87.211:5000/api/health");
    final response = await http.get(url).timeout(Duration(seconds: 5));
    return response.statusCode == 200;
  } catch (e) {
    print('Server connectivity check failed: $e');
    return false;
  }
}