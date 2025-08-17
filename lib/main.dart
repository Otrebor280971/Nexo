import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'login.dart';
import 'homepage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nexo/device_id_generator.dart';
import 'package:nexo/notifications.dart'; // Archivo de notificaciones

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/.env");

  final NotificationService _notificationService = NotificationService();

  await _notificationService.initialize(
    onNotVerified: (String message) {
      // Redirigir al login o mostrar alert
      print('⚠️ $message');
      // Aquí podrías abrir la pantalla de login
    },
  );

  bool started = await _notificationService.startListening();
  if (!started) {
    print('❌ No se pudo iniciar el servicio de notificaciones');
  }

  runApp(const NexoApp());
}

class NexoApp extends StatelessWidget {
  const NexoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(), // Se agregó const
      routes: {
        '/user-type': (context) => UserTypeScreen(),
        '/child-code': (context) => ChildCodeScreen(),
        '/parent-register': (context) => ParentRegisterScreen(),
        '/parent-login': (context) => ParentLoginScreen(), 
        '/parent-home': (context) => ParentHomePage(), // AGREGAR ESTA LÍNEA

      },
    );
  }
}

// Splash Screen con logo y gradiente azul
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simular carga de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/user-type');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo PNG
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(0, 1, 3, 36),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/nexo.png',
                    width: 180,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const CircularProgressIndicator(
                color: Color(0xFFFFFFFF),
              ),
              SizedBox(height: 10),
              Text(
                'Cargando...',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantalla de selección: ¿Papá o Hijo?
class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF010324), // Azul oscuro
              Color(0xFF1a1b4b), // Azul medio
              Color(0xFF2d2e6b), // Azul más claro
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo grande arriba
                Container(
                  width: 160,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 1, 3, 33),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromARGB(0, 1, 0, 0),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/nexo.png',
                      width: 130,
                      height: 170,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                
                const Text(
                  '¿Quién eres?',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 50),
                
                // Botón Padre/Madre
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/parent-login'); // CAMBIAR ESTA LÍNEA
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF535BB0), Color(0xFF535BB0)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF535BB0).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 40,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Soy Padre/Madre',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Quiero supervisar a mi hijo',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Botón Hijo
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/child-code'),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7D82B8), Color(0xFF7D82B8)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7D82B8).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.child_care,
                          size: 50,
                          color: Colors.white,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Soy Hijo/a',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Conectar con mis padres',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//Registro para padres
class ParentRegisterScreen extends StatefulWidget {
  @override
  _ParentRegisterScreenState createState() => _ParentRegisterScreenState();
}

class _ParentRegisterScreenState extends State<ParentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose(){
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //Función para hashear la contraseña
  String _hashPassword(String password) {
    return BCrypt.hashpw(password, BCrypt.gensalt());
  }

  Future<void> _createAccount() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      final rawPassword = _passwordController.text;
      final hashedPassword = _hashPassword(rawPassword);

      print("Contraseña original: $rawPassword");
      print("Contraseña hasheada: $hashedPassword");

      // Simular creacion de cuenta
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cuenta creada con éxito'),
          backgroundColor: Colors.green,
        ),
      );
      // NAVEGAR AL HOME DESPUÉS DEL REGISTRO
      Navigator.pushNamedAndRemoveUntil(
        context, 
        '/parent-home', 
        (route) => false
      );
    }
  }

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
              'Crear cuenta',
              style:TextStyle(color: Colors.white),
            ),
          ),
          body:SingleChildScrollView(
            padding:EdgeInsets.all(24.0),
            child:Form(
              key: _formKey,
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),

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
                        Icons.person_add,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),

                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  Text(
                    'Crea tu cuenta',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: 40),
            
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Nombre completo',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF535BB0)),
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
                        return 'Por favor ingrese su nombre';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      // labelText: 'Correo electrónico',
                      hintText: 'Correo electrónico', // AGREGAR ESTA LÍNEA

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
                      if(!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Por favor ingresa un correo válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
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
                        return 'Por favor ingrese su contraseña';
                      }
                      if (value.length < 8) {
                        return 'La contraseña debe tener al menos 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      hintText: 'Confirmar Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Color(0xFF535BB0)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: Color(0xFF535BB0),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
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
                        return 'Por favor confirma tu contraseña';
                      }
                      if (value != _passwordController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 40),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _createAccount,
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
                          'Crear cuenta',
                          style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                        ),  
                      ),
                  ),
                ),
                SizedBox(height: 30),

                Center(
                  child:GestureDetector(
                    onTap:(){
                      Navigator.pushReplacementNamed(context, '/parent-login');
                    },

                    child: RichText(
                      text: TextSpan(
                        text: '¿Ya tienes una cuenta? ',
                        style: TextStyle(color: Colors.white70),
                        children: [
                            TextSpan(
                              text: 'Inicia sesión',
                              style: TextStyle(
                                color:Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                decorationThickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,)
                ],
              ),
            ),
          ),
        ),
      )
    );
  }   
}

// Pantalla para generar código (Hijo) con gradiente azul claro
class ChildCodeScreen extends StatefulWidget {
  const ChildCodeScreen({super.key});

  @override
  _ChildCodeScreenState createState() => _ChildCodeScreenState();
}


class _ChildCodeScreenState extends State<ChildCodeScreen> {
  String _generatedCode = '';
  bool _isGenerating = false;

  Future<void> _generateCode() async {
    setState(() => _isGenerating = true);

    _generatedCode = await DeviceIdHelper.getToken();
    print("Token único del dispositivo: $_generatedCode");

    print("Código del dispositivo: $_generatedCode");

    setState(() => _isGenerating = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8E9F5), // Fondo claro azulado
              Color(0xFFD6D8ED), // Medio
              Color(0xFFC4C7E5), // Más claro
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Color(0xFF010324)),
            title: const Text(
              'Conectar Dispositivo',
              style: TextStyle(color: Color(0xFF010324)),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icono principal con gradiente morado
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF535BB0), Color(0xFF7D82B8)],
                    ),
                    borderRadius: BorderRadius.circular(60),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF535BB0).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.phone_android,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
                
                const SizedBox(height: 40),
                
                const Text(
                  '¡Hola!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF010324),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                const Text(
                  'Genera un código para que tus padres\npuedan conectar este dispositivo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2d2e6b),
                    height: 1.5,
                  ),
                ),
                
                const SizedBox(height: 50),
                
                // Área del código
                if (_generatedCode.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF535BB0), width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Tu código es:',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF2d2e6b),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          _generatedCode,
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF535BB0),
                            letterSpacing: 8,
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Comparte este código con tus padres',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2d2e6b),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                ] else ...[
                  // Botón para generar código inicial
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isGenerating ? null : _generateCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF535BB0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isGenerating
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Generando...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.qr_code, color: Colors.white),
                                SizedBox(width: 10),
                                Text(
                                  'Generar Código',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
                
                const SizedBox(height: 40),
                
                // Instrucciones con fondo azul claro
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F3FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD6D8ED)),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.info, color: Color(0xFF535BB0), size: 20),
                          SizedBox(width: 10),
                          Text(
                            'Instrucciones:',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF010324),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        '1. Genera tu código único\n'
                        '2. Compártelo con tus padres\n'
                        '3. Ellos lo ingresarán en su app\n'
                        '4. ¡Listo! Tu dispositivo estará conectado',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2d2e6b),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}