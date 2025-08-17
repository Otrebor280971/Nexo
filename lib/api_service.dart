import 'package:http/http.dart' as http;
import 'dart:convert';

Future<bool> registerDevice(String token, String parentId, String alias) async {
  final url = Uri.parse("http://10.50.87.211:5000/api/childDevices/");

  final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({
      "code": token,
      "parentId": parentId,
      "alias": alias
    }),
  );

  if (response.statusCode == 201) {
    return true;
  } else {
    return false;
  }
}

Future<String> login(String email, String password) async {
  final url = Uri.parse("http://10.50.87.211:5000/api/users/login");

  final response = await http.post(
    url, 
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "email": email,
      "passwordHash": password
    }),
  );

  if (response.statusCode == 200){
    final responseData = json.decode(response.body);
    final String userId = responseData['id'];
    return userId;
  }else {
    // Manejar errores (por ejemplo, credenciales incorrectas o error del servidor)
    // Puedes decodificar el error para obtener el mensaje:
    final errorData = json.decode(response.body);
    final String errorMessage = errorData['error'] ?? 'Unknown error';
    
    // O puedes lanzar una excepción para un mejor manejo de errores en tu app
    throw Exception('Failed to login: $errorMessage');
  }
}