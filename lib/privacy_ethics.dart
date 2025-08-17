// privacy_ethics.dart
import 'package:flutter/material.dart';

class PrivacyEthicsScreen extends StatefulWidget {
  @override
  _PrivacyEthicsScreenState createState() => _PrivacyEthicsScreenState();
}

class _PrivacyEthicsScreenState extends State<PrivacyEthicsScreen> {
  bool _parentConsent = false;
  bool _childNotified = false;
  bool _dataUnderstanding = false;

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
              // Header
              _buildHeader(),
              
              // Contenido con scroll
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeSection(),
                      SizedBox(height: 30),
                      _buildDataProtectionSection(),
                      SizedBox(height: 25),
                      _buildTransparencySection(),
                      SizedBox(height: 25),
                      _buildConsentSection(),
                      SizedBox(height: 30),
                      _buildContinueButton(),
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
                  'Privacidad y Ética',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Protegemos a tu familia',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.security, color: Color(0xFF4CAF50), size: 28),
              ),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  'Tu confianza es nuestra prioridad',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2d2e6b),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Text(
            'Nexo está diseñado para proteger a tu hijo/a manteniendo la transparencia y respetando los derechos de toda la familia.',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF757575),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataProtectionSection() {
    return _buildInfoCard(
      icon: Icons.shield_outlined,
      iconColor: Color(0xFF2196F3),
      title: '¿Qué datos protegemos?',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataPoint('✅ Los mensajes se analizan en el dispositivo'),
          _buildDataPoint('✅ No guardamos contenido de conversaciones'),
          _buildDataPoint('✅ Solo almacenamos alertas de seguridad'),
          _buildDataPoint('✅ Los datos se cifran de extremo a extremo'),
          SizedBox(height: 10),
          Text(
            'Nexo funciona como un "filtro inteligente" que solo te notifica cuando detecta riesgos potenciales.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF757575),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransparencySection() {
    return _buildInfoCard(
      icon: Icons.visibility_outlined,
      iconColor: Color(0xFFFF9800),
      title: 'Transparencia con tu hijo/a',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDataPoint('👨‍👩‍👧‍👦 Tu hijo/a sabe que Nexo está activo'),
          _buildDataPoint('💬 Fomenta el diálogo sobre seguridad digital'),
          _buildDataPoint('🎯 Se enfoca en protección, no en espionaje'),
          _buildDataPoint('📚 Incluye recursos educativos para ambos'),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFFFFB74D)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, color: Color(0xFFFF9800), size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Recomendación: Habla con tu hijo/a sobre por qué usas Nexo',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE65100),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentSection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Color(0xFF535BB0).withOpacity(0.3)),
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
            'Compromisos éticos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2d2e6b),
            ),
          ),
          SizedBox(height: 15),
          
          _buildCheckboxTile(
            value: _parentConsent,
            onChanged: (value) => setState(() => _parentConsent = value ?? false),
            title: 'Como padre/madre, acepto usar Nexo de manera responsable',
            subtitle: 'Para proteger, no para controlar excesivamente',
          ),
          
          _buildCheckboxTile(
            value: _childNotified,
            onChanged: (value) => setState(() => _childNotified = value ?? false),
            title: 'He conversado con mi hijo/a sobre el uso de Nexo',
            subtitle: 'La transparencia fortalece la confianza familiar',
          ),
          
          _buildCheckboxTile(
            value: _dataUnderstanding,
            onChanged: (value) => setState(() => _dataUnderstanding = value ?? false),
            title: 'Entiendo qué datos se procesan y cómo se protegen',
            subtitle: 'Análisis local, cifrado seguro, sin almacenamiento de conversaciones',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget content,
  }) {
    return Container(
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2d2e6b),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          content,
        ],
      ),
    );
  }

  Widget _buildDataPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF757575),
          height: 1.4,
        ),
      ),
    );
  }

  Widget _buildCheckboxTile({
    required bool value,
    required Function(bool?) onChanged,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: Color(0xFF535BB0),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2d2e6b),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
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

  Widget _buildContinueButton() {
    bool canContinue = _parentConsent && _childNotified && _dataUnderstanding;
    
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: canContinue ? () {
          // Regresar true para indicar que se completó la configuración
          Navigator.pop(context, true);
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canContinue ? Color(0xFF535BB0) : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: canContinue ? 5 : 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (canContinue) ...[
              Icon(Icons.verified_user, color: Colors.white, size: 20),
              SizedBox(width: 8),
            ],
            Text(
              canContinue ? 'Continuar con Nexo' : 'Completa todos los compromisos',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}