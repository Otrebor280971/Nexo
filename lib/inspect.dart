// inspect.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {

  final String _modelo = "gemini-pro"; // Usaremos Gemini Pro por su eficiencia y bajo costo
  
  late final GenerativeModel _model;

  GeminiService() {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API Key no encontrada en el archivo .env');
    }
    _model = GenerativeModel(model: _modelo, apiKey: apiKey);
  }

  /// Analiza un mensaje de texto para clasificarlo como "Negativo" o "Seguro"
  /// Retorna un string con la clasificación y la razón si es negativa.
  Future<String> analizarMensaje(String mensaje) async {
    final prompt = [
      Content.text(
        'Clasifica este mensaje como "Negativo" o "Seguro" para un niño de 9 a 15 años. '
        'Analiza el tono y el contenido para identificar posibles amenazas, grooming o lenguaje inapropiado. '
        'Responde solo con la categoría y justifica brevemente si es negativo. '
        'Ejemplos de grooming y acercamientos inapropiados incluyen: '
        '"quedamos", "nos vemos", "dónde vives", "envíame una foto", '
        '"tienes secretos para mí?", "te puedo dar regalos?", "tus papás no deben saber", '
        '"me cuentas tus cosas personales", "ven a mi casa", "te sigo en redes", "quiero conocerte mejor". '
        'Mensaje a analizar: "$mensaje"'
      )
    ];

    try {
      final response = await _model.generateContent(prompt);
      final resultado = response.text;
      
      if (resultado == null) {
        return "Respuesta vacía del modelo.";
      }

      return resultado;
    } catch (e) {
      return "Error al analizar el mensaje: $e";
    }
  }
}