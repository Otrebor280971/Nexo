import 'package:flutter/material.dart';
import 'package:notifications/notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nexo/inspect.dart'; // Tu servicio Gemini

class NotificationService {
  final GeminiService _geminiService = GeminiService();
  final Notifications _notifications = Notifications();

  // Plugin para notificaciones locales
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    _initLocalNotifications();
  }

  /// Inicializa el plugin de notificaciones locales
  void _initLocalNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    _localNotifications.initialize(initializationSettings);
  }

  /// Inicia la escucha de notificaciones
  Future<void> startListening() async {
    try {
      // Solicitar permisos
      bool hasPermission = await _notifications.hasPermission();
      if (!hasPermission) {
        await _notifications.requestPermission();
      }

      // Escuchar notificaciones
      _notifications.notificationStream.listen((NotificationEvent event) async {
        if (event.text != null && event.text!.isNotEmpty) {
          try {
            String resultadoAnalisis =
                await _geminiService.analizarMensaje(event.text!);

            // Si el mensaje es negativo, mostrar alerta
            if (resultadoAnalisis.startsWith('Negativo')) {
              _mostrarAlerta(resultadoAnalisis);
            }
          } catch (e) {
            print('Error analizando notificación: $e');
          }
        }
      });

      print('Escucha de notificaciones iniciada.');
    } catch (e) {
      print('Error al iniciar la escucha de notificaciones: $e');
    }
  }

  /// Muestra alerta mediante notificación local
  Future<void> _mostrarAlerta(String mensaje) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'alert_channel',
      'Alertas de seguridad',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await _localNotifications.show(
        0, '¡ALERTA DE SEGURIDAD!', mensaje, platformDetails);
  }
}
