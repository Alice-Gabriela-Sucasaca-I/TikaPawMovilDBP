import 'package:flutter/material.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';

class RegisterRefugioPage extends StatefulWidget {
  const RegisterRefugioPage({super.key});

  @override
  State<RegisterRefugioPage> createState() => _RegisterRefugioPageState();
}

class _RegisterRefugioPageState extends State<RegisterRefugioPage> {
  final TextEditingController nombreCentroController = TextEditingController();
  final TextEditingController nombreEncargadoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController direccionController = TextEditingController();
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
        '/refugios/register',
        data: {
          'nombrecentro': nombreCentroController.text.trim(),
          'nombreencargado': nombreEncargadoController.text.trim(),
          'correo': correoController.text.trim(),
          'password': passwordController.text.trim(),
          'telefono': telefonoController.text.trim(),
          'direccion': direccionController.text.trim(),
        },
      );

      final body = response.data;

      print('Código de estado: ${response.statusCode}');
      print('Respuesta JSON: $body');

      if (response.statusCode == 201 && body['success'] == true) {
        Navigator.pushReplacementNamed(context, '/loginrefugio');
      } else {
        setState(() {
          mensaje = 'Error: ${body['message'] ?? 'No se pudo registrar el refugio'}';
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
      appBar: AppBar(title: const Text('Registro de Refugios - TikiTiki')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nombreCentroController,
              decoration: const InputDecoration(labelText: 'Nombre del Refugio'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nombreEncargadoController,
              decoration: const InputDecoration(labelText: 'Nombre del Encargado'),
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
              controller: direccionController,
              decoration: const InputDecoration(labelText: 'Dirección'),
            ),
            const SizedBox(height: 20),
            cargando
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Registrar Refugio'),
                  ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/loginrefugio');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Volver al Login de Refugios'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Registrar como Usuario'),
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