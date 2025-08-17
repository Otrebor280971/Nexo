import 'package:notifications/notifications.dart';
import 'package:flutter/material.dart'; // Necesario para el ScaffoldMessenger

import 'package:nexo/inspect.dart'; // Importa tu servicio de Gemini

// Este servicio se encargará de escuchar las notificaciones y analizarlas
class NotificationService {

  final GeminiService _geminiService = GeminiService();
  final Notifications _notifications = Notifications();
  final BuildContext _context;

  NotificationService(this._context);

  Future<void> startListening() async {
    try {
      // Solicitar el permiso para acceder a las notificaciones
      bool hasPermission = await _notifications.has  ;
      if (!hasPermission) {
        await _notifications.requestPermission();
      }

      // Escuchar el stream de notificaciones
      _notifications.notificationStream.listen((NotificationEvent event) async {
        if (event.text != null && event.text!.isNotEmpty) {
          // Analizar el texto de la notificación con GeminiService
          String resultadoAnalisis = await _geminiService.analizarMensaje(event.text!);

          // Mostrar una alerta si el mensaje es Negativo
          if (resultadoAnalisis.startsWith('Negativo')) {
            _mostrarAlerta(resultadoAnalisis);
          }
        }
      });
      print('Escucha de notificaciones iniciada.');
    } catch (e) {
      print('Error al iniciar la escucha de notificaciones: $e');
    }
  }

  void _mostrarAlerta(String mensaje) {
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: Text(
          '¡ALERTA DE SEGURIDAD! ' + mensaje,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 10),
      ),
    );
  }
}