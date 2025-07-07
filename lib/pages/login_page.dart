import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String mensaje = '';
  bool cargando = false;

  final Color coral = const Color(0xFFF4A484);
  final Color coralDark = const Color(0xFFE8926E);
  final Color fondoSuave = Color(0xFFFDF7F4);

  Future<void> login() async {
    FocusScope.of(context).unfocus();
    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final response = await DioClient.dio.post(
        '/usuarios/login',
        data: {
          'correo': correoController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final body = response.data;

      if (response.statusCode == 200 && body['success'] == true) {
        Navigator.pushReplacementNamed(context, '/usuario');
      } else {
        setState(() {
          mensaje = '❌ ${body['message'] ?? 'No se pudo iniciar sesión'}';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = '⚠️ Error de red: $e';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoSuave,
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: coral,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 120,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bienvenido a TikaPaw 🐾',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: correoController,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                prefixIcon: const Icon(Icons.email_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            cargando
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: login,
                    icon: const Icon(Icons.login),
                    label: const Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: coralDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/crearcuenta'),
              icon: const Icon(Icons.person_add_alt_1),
              label: const Text('Crear Cuenta de Usuario'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: coralDark),
                foregroundColor: coralDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/registrarrefugio'),
              icon: const Icon(Icons.home_work_outlined),
              label: const Text('Registrar Refugio'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: coralDark),
                foregroundColor: coralDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton.icon(
              onPressed: () => Navigator.pushNamed(context, '/loginrefugio'),
              icon: Icon(Icons.account_circle_outlined, color: coralDark),
              label: Text('Login como Refugio', style: TextStyle(color: coralDark)),
            ),
            const SizedBox(height: 20),
            if (mensaje.isNotEmpty)
              Text(
                mensaje,
                style: TextStyle(
                  color: mensaje.startsWith('✅') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/about'),
        backgroundColor: coral,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
