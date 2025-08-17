// homepage.dart
import 'package:flutter/material.dart';

class ParentHomePage extends StatefulWidget {
  @override
  _ParentHomePageState createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  // Lista de dispositivos conectados
  List<Device> connectedDevices = [];

  // Lista de alertas de mensajes sospechosos
  List<SuspiciousAlert> suspiciousAlerts = [];

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
                      // Sección de dispositivos
                      _buildDevicesSection(),
                      SizedBox(height: 30),
                      
                      // Sección de alertas
                      _buildAlertsSection(),
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
              onTap: () => _showAddDeviceDialog(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFF535BB0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'Agregar',
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
              'Agrega el primer dispositivo de tu hijo',
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
                hintText: 'Código de 6 dígitos',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: Icon(Icons.qr_code),
              ),
              keyboardType: TextInputType.number,
              maxLength: 6,
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
              if (_codeController.text.length == 6) {
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
  void _addDevice(String code) {
    setState(() {
      connectedDevices.add(Device(
        id: code,
        name: 'Dispositivo ${code}',
      ));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dispositivo conectado exitosamente'),
        backgroundColor: Colors.green,
      ),
    );
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