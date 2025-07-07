import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/tiki_navbar.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  void _abrirSitioWeb() async {
    const url = 'https://tikapawdbp-48n3.onrender.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    const accentColor = Color(0xFFF4A484);
    const textColor = Colors.black87;
    const subtitleColor = Colors.black54;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Sobre TikaPaw',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: accentColor,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Logo centrado (local)
          Center(
            child: Image.asset(
              'assets/logo.png',
              height: 140,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 24),

          // Título
          const Text(
            '🐾 ¡Bienvenido a TikaPaw!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // Descripción
          const Text(
            'TikaPaw es una plataforma que conecta personas con refugios de animales para fomentar la adopción responsable. Nuestra misión es dar visibilidad a mascotas que buscan un hogar y ayudar a los refugios a llegar más lejos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 32),

          // Misión
          const Text(
            '🌎 Nuestra Misión',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Promover el bienestar animal conectando personas y albergues. Darle visibilidad a quienes ayudan.',
            style: TextStyle(fontSize: 16, color: subtitleColor, height: 1.5),
          ),
          const SizedBox(height: 24),

          // Colaborar
          const Text(
            '🤝 Colabora con Nosotros',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Si tienes un refugio o quieres ser parte de esta causa, únete. Regístrate y comparte historias de tus mascotas en adopción.',
            style: TextStyle(fontSize: 16, color: subtitleColor, height: 1.5),
          ),
          const SizedBox(height: 32),

          // Botón a la web
          ElevatedButton.icon(
            onPressed: _abrirSitioWeb,
            icon: const Icon(Icons.public),
            label: const Text('Visita nuestro sitio web'),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Footer
          Center(
            child: Column(
              children: [
                const Text(
                  'TikaPaw - Adopta con el corazón 🐶🐱',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.black45,
                  ),
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://moviltika-production.up.railway.app/uploads/logo.png',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 60),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: -1),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirSitioWeb,
        backgroundColor: accentColor,
        child: const Icon(Icons.pets),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
