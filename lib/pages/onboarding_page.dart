import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final Color coral = const Color(0xFFF4A484);

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/logo.png",
      "title": "Bienvenido a TikaPaw",
      "text": "Conecta con refugios y encuentra a tu compañero ideal.",
    },
    {
      "image": "assets/logo.png",
      "title": "Adopta con Amor",
      "text": "Conoce mascotas esperando una segunda oportunidad.",
    },
    {
      "image": "assets/logo.png",
      "title": "Sé parte del cambio",
      "text": "Únete a nuestra comunidad y salva vidas.",
    },
  ];

  void _siguientePagina() {
    if (currentIndex < onboardingData.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    } else {
      //Navigator.pushReplacementNamed(context, '/login');
      Navigator.pushReplacementNamed(context, '/mainwrapper');
      //Navigator.pushReplacementNamed(context, '/');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemBuilder: (context, index) {
                final data = onboardingData[index];
                return Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(data["image"]!, height: 160),
                      const SizedBox(height: 30),
                      Text(
                        data["title"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: coral,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        data["text"]!,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            child: ElevatedButton(
              onPressed: _siguientePagina,
              style: ElevatedButton.styleFrom(
                backgroundColor: coral,
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                currentIndex == onboardingData.length - 1
                    ? '¡Comenzar!'
                    : 'Siguiente',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
