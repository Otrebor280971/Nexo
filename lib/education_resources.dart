// education_resources.dart
import 'package:flutter/material.dart';

class EducationResourcesScreen extends StatefulWidget {
  @override
  _EducationResourcesScreenState createState() => _EducationResourcesScreenState();
}

class _EducationResourcesScreenState extends State<EducationResourcesScreen> {
  int selectedCategoryIndex = 0;

  final List<EducationCategory> categories = [
    EducationCategory(
      title: 'Ciberacoso',
      icon: Icons.shield_outlined,
      color: Color(0xFFE53E3E),
      resources: [
        EducationResource(
          title: '¿Cómo identificar ciberacoso?',
          description: 'Señales de alerta que debes observar en tu hijo/a',
          actionTitle: 'Qué hacer si detectas ciberacoso',
          actionSteps: [
            'Mantén la calma y escucha sin juzgar',
            'Documenta la evidencia (capturas de pantalla)',
            'Bloquea y reporta al agresor en la plataforma',
            'Contacta a la escuela si involucra compañeros',
            'Considera apoyo psicológico profesional'
          ],
          tips: [
            'Cambios de humor repentinos después de usar el dispositivo',
            'Evitar actividades sociales o escolares',
            'Problemas para dormir o pesadillas',
            'Reticencia a hablar sobre actividades en línea'
          ]
        ),
        EducationResource(
          title: 'Prevención del ciberacoso',
          description: 'Estrategias para crear un entorno digital seguro',
          actionTitle: 'Medidas preventivas',
          actionSteps: [
            'Enseña sobre la importancia del respeto en línea',
            'Establece reglas claras sobre el uso de internet',
            'Mantén dispositivos en áreas comunes de la casa',
            'Revisa regularmente la configuración de privacidad',
            'Fomenta la comunicación abierta sobre experiencias digitales'
          ],
          tips: [
            'Habla sobre la "huella digital" y sus consecuencias',
            'Enseña a no compartir información personal',
            'Explica cómo reportar comportamientos inapropiados',
            'Modela un comportamiento digital positivo'
          ]
        ),
      ],
    ),
    EducationCategory(
      title: 'Grooming',
      icon: Icons.warning_outlined,
      color: Color(0xFFFF6B35),
      resources: [
        EducationResource(
          title: 'Reconocer señales de grooming',
          description: 'Técnicas que usan los depredadores para ganar confianza',
          actionTitle: 'Pasos inmediatos si sospechas grooming',
          actionSteps: [
            'NO elimines evidencia, toma capturas de pantalla',
            'Contacta inmediatamente a las autoridades',
            'Separa al menor del dispositivo temporalmente',
            'Busca apoyo psicológico especializado',
            'Reporta a la plataforma donde ocurrió el contacto'
          ],
          tips: [
            'Regalos inesperados o dinero',
            'Conversaciones secretas o "especiales"',
            'Solicitudes de fotos o información personal',
            'Intentos de aislar al menor de amigos/familia',
            'Propuestas de encuentros presenciales'
          ]
        ),
        EducationResource(
          title: 'Educación preventiva sobre grooming',
          description: 'Cómo enseñar a tu hijo/a a protegerse',
          actionTitle: 'Conversaciones importantes',
          actionSteps: [
            'Explica que los extraños en línea pueden mentir sobre su identidad',
            'Enseña que nunca debe compartir información personal',
            'Practica escenarios "¿qué harías si...?"',
            'Asegúrate de que sepa que puede contarte cualquier cosa',
            'Revisa periódicamente sus contactos y conversaciones'
          ],
          tips: [
            'Usa ejemplos apropiados para la edad',
            'No uses miedo, sino educación y empoderamiento',
            'Refuerza que no se meterá en problemas por contarte',
            'Establece códigos familiares para situaciones incómodas'
          ]
        ),
      ],
    ),
    EducationCategory(
      title: 'Contenido Inapropiado',
      icon: Icons.visibility_off_outlined,
      color: Color(0xFF8E44AD),
      resources: [
        EducationResource(
          title: 'Filtrar contenido por edad',
          description: 'Herramientas y configuraciones para proteger a tu hijo/a',
          actionTitle: 'Configuraciones recomendadas',
          actionSteps: [
            'Activa el control parental en el router de casa',
            'Configura filtros en cada dispositivo individualmente',
            'Usa DNS seguros como OpenDNS o CleanBrowsing',
            'Instala extensiones de navegador para filtrado',
            'Revisa y ajusta configuraciones mensualmente'
          ],
          tips: [
            'Los filtros no son 100% efectivos, supervisa activamente',
            'Enseña sobre contenido apropiado vs inapropiado',
            'Crea listas de sitios web aprobados para niños pequeños',
            'Considera horarios específicos para uso de internet'
          ]
        ),
        EducationResource(
          title: 'Qué hacer si encuentra contenido inapropiado',
          description: 'Respuestas constructivas y educativas',
          actionTitle: 'Protocolo de respuesta',
          actionSteps: [
            'Mantén la calma, evita reacciones exageradas',
            'Pregunta cómo llegó a ese contenido',
            'Explica por qué es inapropiado de manera simple',
            'Refuerza que no está en problemas por contarte',
            'Ajusta las medidas de protección según sea necesario'
          ],
          tips: [
            'Convierte el incidente en una oportunidad educativa',
            'Explica las consecuencias emocionales del contenido inadecuado',
            'Refuerza los valores familiares de manera positiva',
            'Considera apoyo profesional si el contenido fue traumático'
          ]
        ),
      ],
    ),
    EducationCategory(
      title: 'Tiempo de Pantalla',
      icon: Icons.schedule_outlined,
      color: Color(0xFF00BCD4),
      resources: [
        EducationResource(
          title: 'Límites saludables por edad',
          description: 'Recomendaciones de expertos para cada etapa',
          actionTitle: 'Guías por grupo de edad',
          actionSteps: [
            '2-5 años: Máximo 1 hora de contenido de calidad',
            '6-12 años: Equilibrar tiempo digital con actividades físicas',
            '13-15 años: Enfocarse en contenido educativo y creativo',
            'Todos: Sin pantallas 1 hora antes de dormir',
            'Establece "zonas libres" como comedor familiar'
          ],
          tips: [
            'Sé un modelo a seguir en tu propio uso de pantallas',
            'Crea actividades familiares sin dispositivos',
            'Usa aplicaciones de control de tiempo con transparencia',
            'Involucra a tu hijo/a en crear las reglas familiares'
          ]
        ),
      ],
    ),
    EducationCategory(
      title: 'Privacidad Digital',
      icon: Icons.lock_outline,
      color: Color(0xFF4CAF50),
      resources: [
        EducationResource(
          title: 'Proteger información personal',
          description: 'Enseña a tu hijo/a sobre la privacidad en línea',
          actionTitle: 'Información que NUNCA debe compartir',
          actionSteps: [
            'Nombre completo, dirección o teléfono',
            'Nombre de la escuela o lugares que frecuenta',
            'Información sobre horarios o rutinas familiares',
            'Fotografías que muestren ubicaciones reconocibles',
            'Contraseñas o información de cuentas familiares'
          ],
          tips: [
            'Enseña sobre configuraciones de privacidad en redes sociales',
            'Explica por qué los "extraños amigables" pueden ser peligrosos',
            'Practica identificar intentos de obtener información personal',
            'Revisa periódicamente qué información está visible públicamente'
          ]
        ),
      ],
    ),
  ];

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
              _buildHeader(),
              Expanded(
                child: Row(
                  children: [
                    // Menú lateral de categorías
                    Container(
                      width: 120,
                      child: _buildCategoryMenu(),
                    ),
                    // Contenido principal
                    Expanded(
                      child: _buildResourceContent(),
                    ),
                  ],
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_back, color: Colors.white, size: 24),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Educación Digital',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Recursos y guías para padres',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryMenu() {
    return Container(
      margin: EdgeInsets.only(left: 20, bottom: 20),
      child: Column(
        children: categories.asMap().entries.map((entry) {
          int index = entry.key;
          EducationCategory category = entry.value;
          bool isSelected = selectedCategoryIndex == index;

          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? category.color.withOpacity(0.2) : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? category.color : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    category.icon,
                    color: isSelected ? category.color : Colors.white70,
                    size: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    category.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white70,
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildResourceContent() {
    EducationCategory selectedCategory = categories[selectedCategoryIndex];
    
    return Container(
      margin: EdgeInsets.only(right: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la categoría seleccionada
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: selectedCategory.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: selectedCategory.color.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  selectedCategory.icon,
                  color: selectedCategory.color,
                  size: 32,
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Text(
                    selectedCategory.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          
          // Lista de recursos
          Expanded(
            child: ListView.builder(
              itemCount: selectedCategory.resources.length,
              itemBuilder: (context, index) {
                return _buildResourceCard(selectedCategory.resources[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceCard(EducationResource resource) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resource.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d2e6b),
            ),
          ),
          SizedBox(height: 8),
          Text(
            resource.description,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
            ),
          ),
          SizedBox(height: 15),
          
          if (resource.tips.isNotEmpty) ...[
            Text(
              'Señales de alerta:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2d2e6b),
              ),
            ),
            SizedBox(height: 8),
            ...resource.tips.map((tip) => _buildTipItem(tip)).toList(),
            SizedBox(height: 15),
          ],
          
          Text(
            resource.actionTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2d2e6b),
            ),
          ),
          SizedBox(height: 8),
          ...resource.actionSteps.asMap().entries.map((entry) {
            int index = entry.key;
            String step = entry.value;
            return _buildActionStep(index + 1, step);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Color(0xFFFF9800),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionStep(int stepNumber, String step) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              step,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF2d2e6b),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelos de datos
class EducationCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<EducationResource> resources;

  EducationCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.resources,
  });
}

class EducationResource {
  final String title;
  final String description;
  final String actionTitle;
  final List<String> actionSteps;
  final List<String> tips;

  EducationResource({
    required this.title,
    required this.description,
    required this.actionTitle,
    required this.actionSteps,
    this.tips = const [],
  });
}