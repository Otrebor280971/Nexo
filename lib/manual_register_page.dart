import 'package:flutter/material.dart';

class ManualRegisterPage extends StatefulWidget {
  @override
  _ManualRegisterPageState createState() => _ManualRegisterPageState();
}

class _ManualRegisterPageState extends State<ManualRegisterPage> {
  final _controller = TextEditingController();
  String _status = "";

  void _registerToken() {
    String token = _controller.text.trim();

    if (token.length != 8) {
      setState(() {
        _status = "Token inválido, debe tener 8 caracteres";
      });
      return;
    }

    // Aquí puedes enviar el token al backend para registrar el dispositivo
    // Por ejemplo: await api.registerDevice(token);
    

    setState(() {
      _status = "Token registrado correctamente: $token";
    });
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
