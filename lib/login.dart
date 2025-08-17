// parent_login_screen.dart
import 'package:flutter/material.dart';

class ParentLoginScreen extends StatefulWidget {
  @override
  _ParentLoginScreenState createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends State<ParentLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  // bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Función eliminada - se puede agregar cuando se implemente la verificación real

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final email = _emailController.text;
      final password = _passwordController.text;

      print("Email: $email");
      print("Contraseña ingresada: $password");

      // Simular proceso de login
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isLoading = false);

      // Simular login exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando sesión...'),
          backgroundColor: Colors.green,
        ),
      );

      // Aquí navegarías a la pantalla principal
      // Navigator.pushReplacementNamed(context, '/home');
    }
  }

  // Future<void> _forgotPassword() async {
  //   if (_emailController.text.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Por favor ingresa tu correo electrónico'),
  //         backgroundColor: Colors.orange,
  //       ),
  //     );
  //     return;
  //   }

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Instrucciones enviadas a ${_emailController.text}'),
  //       backgroundColor: Colors.blue,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF010324), // Azul oscuro
              Color(0xFF1a1b4b), // Azul medio
              Color(0xFF2d2e6b), // Azul más claro
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            title: Text(
              'Iniciar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

                  // Icono de login
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF535BB0), Color(0xFF7D82B8)],
                        ),
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF535BB0).withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.login,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Títulos
                  Text(
                    '¡Bienvenido de vuelta!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    'Inicia sesión en tu cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Campo de correo electrónico
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.email, color: Color(0xFF535BB0)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: TextStyle(color: Color(0xFF2d2e6b)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu correo electrónico';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Campo de contraseña
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF535BB0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFF535BB0),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      labelStyle: TextStyle(color: Color(0xFF2d2e6b)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa tu contraseña';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Recordarme y ¿Olvidaste tu contraseña?
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Row(
                  //       children: [
                  //         Checkbox(
                  //           value: _rememberMe,
                  //           onChanged: (value) {
                  //             setState(() {
                  //               _rememberMe = value ?? false;
                  //             });
                  //           },
                  //           activeColor: Color(0xFF535BB0),
                  //           checkColor: Colors.white,
                  //         ),
                  //         Text(
                  //           'Recordarme',
                  //           style: TextStyle(color: Colors.white70),
                  //         ),
                  //       ],
                  //     ),
                  //     GestureDetector(
                  //       onTap: _forgotPassword,
                  //       child: Text(
                  //         '¿Olvidaste tu contraseña?',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontWeight: FontWeight.bold,
                  //           decoration: TextDecoration.underline,
                  //         ),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  SizedBox(height: 30),

                  // Botón de iniciar sesión
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF535BB0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                          : Text(
                              'Iniciar Sesión',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 40),

                  // Divisor "O"
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.white38,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'O',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 1,
                          color: Colors.white38,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Botón de Google (opcional)
                  // SizedBox(
                  //   width: double.infinity,
                  //   height: 50,
                  //   child: OutlinedButton.icon(
                  //     onPressed: () {
                  //       ScaffoldMessenger.of(context).showSnackBar(
                  //         SnackBar(
                  //           content: Text('Inicio con Google - en desarrollo'),
                  //           backgroundColor: Colors.orange,
                  //         ),
                  //       );
                  //     },
                  //     icon: Icon(Icons.g_mobiledata, color: Colors.white, size: 24),
                  //     label: Text(
                  //       'Continuar con Google',
                  //       style: TextStyle(
                  //         fontSize: 16,
                  //         color: Colors.white,
                  //       ),
                  //     ),
                  //     style: OutlinedButton.styleFrom(
                  //       side: BorderSide(color: Colors.white38),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(12),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 10),

                  // ¿No tienes cuenta? Regístrate
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/parent-register');
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '¿No tienes una cuenta? ',
                          style: TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: 'Regístrate',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}