import 'package:flutter/material.dart';
import 'package:nexo/api_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ManualRegisterPage extends StatefulWidget {
  const ManualRegisterPage({super.key});

  @override
  ManualRegisterPageState createState() => ManualRegisterPageState();
}

class ManualRegisterPageState extends State<ManualRegisterPage> {
  final _controller = TextEditingController();
  String _status = "";

  void _registerToken() async{
    String token = _controller.text.trim();

    if (token.length != 8) {
      setState(() {
        _status = "Token inválido, debe tener 8 caracteres";
      });
      return;
    }

    const storage = FlutterSecureStorage();
    String? parentId = await storage.read(key: 'userId');
    String alias = "Mi Celular";
    //String parentId = "66b2f84a87dbfc02b4b8e321";

    if (parentId == null) {
      setState(() {
        _status = "Error: ID de usuario no encontrado. Por favor, inicie sesión de nuevo.";
      });
      // O puedes navegar de regreso a la pantalla de login
      // Navigator.pushReplacementNamed(context, '/parent-login');
      return;
    }

    bool success = await registerDevice(token, parentId, alias);

    if(success){
      setState(() {
        _status = "Token registrado";
      });
    } else {
      setState(() {
        _status = "Error al registrar el token";
      });
    }
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar dispositivo")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Ingrese el token del dispositivo controlado:", style: TextStyle(fontSize: 18)),
            SizedBox(height: 15),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Token de 8 caracteres",
              ),
              maxLength: 8,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _registerToken,
              child: Text("Registrar"),
            ),
            SizedBox(height: 20),
            Text(_status, style: TextStyle(fontSize: 16, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
