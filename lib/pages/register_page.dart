import 'package:flutter/material.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  String mensaje = '';
  bool cargando = false;

  Future<void> register() async {
    FocusScope.of(context).unfocus();
    setState(() {
      cargando = true;
      mensaje = '';
    });

    try {
      final response = await DioClient.dio.post(
        '/usuarios/register',
        data: {
          'nombre': nombreController.text.trim(),
          'correo': correoController.text.trim(),
          'password': passwordController.text.trim(),
          'telefono': telefonoController.text.trim(),
          'edad': int.tryParse(edadController.text.trim()) ?? 0,
        },
      );

      final body = response.data;

      print('Código de estado: ${response.statusCode}');
      print('Respuesta JSON: $body');

      if (response.statusCode == 201 && body['success'] == true) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() {
          mensaje = 'Error: ${body['message'] ?? 'No se pudo registrar el usuario'}';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = 'Error de red: $e';
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
      appBar: AppBar(title: const Text('Registro - TikiTiki')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: telefonoController,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: edadController,
              decoration: const InputDecoration(labelText: 'Edad'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Registrar Usuario'),
                  ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Volver al Login'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/registerrefugio');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Registrar Refugio'),
            ),
            const SizedBox(height: 20),
            Text(
              mensaje,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/about');
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}