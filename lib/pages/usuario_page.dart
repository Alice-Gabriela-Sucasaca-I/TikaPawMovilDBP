import 'package:flutter/material.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';

class UsuarioPage extends StatefulWidget {
  const UsuarioPage({super.key});

  @override
  State<UsuarioPage> createState() => _UsuarioPageState();
}

class _UsuarioPageState extends State<UsuarioPage> {
  Map<String, dynamic>? usuario;
  List<dynamic> solicitudes = [];
  String mensaje = '';
  bool cargando = true;

  final Color baseColor = const Color(0xFFF2BA9D);
  final Color secondaryColor = const Color(0xFFEC8C68);
  final Color accentColor = const Color(0xFFF88064);

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final authResponse = await DioClient.dio.get('/usuarios/api/auth/check');
      final authData = authResponse.data;

      if (authData['isValid'] == true && authData['tipo'] == 'usuario') {
        setState(() {
          usuario = {
            'nombre': authData['username'],
            'edad': authData['edad'],
            'correo': authData['correo'],
            'telefono': authData['telefono'],
            'userId': authData['userId'],
          };
        });
        await cargarSolicitudes(authData['userId']);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      setState(() => mensaje = 'Error al cargar los datos: $e');
    } finally {
      setState(() => cargando = false);
    }
  }

  Future<void> cargarSolicitudes(int userId) async {
    try {
      final response = await DioClient.dio.get(
        '/solicitudes/solicitudes',
        queryParameters: {'tipo': 'usuario', 'id': userId},
      );

      final data = response.data;

      if (data['success'] == true && data['solicitudes'] != null) {
        setState(() {
          solicitudes = data['solicitudes'];
        });
      } else {
        setState(() => mensaje = 'No hay solicitudes.');
      }
    } catch (e) {
      setState(() => mensaje = 'Error al cargar solicitudes: $e');
    }
  }

  Future<void> logout() async {
    try {
      final response = await DioClient.dio.post('/usuarios/logout');
      final data = response.data;

      if (data['success'] == true) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        setState(() => mensaje = 'Error al cerrar sesión.');
      }
    } catch (e) {
      setState(() => mensaje = 'Error al cerrar sesión: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Perfil Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: usuario == null
          ? Center(child: Text(mensaje))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.pets, size: 100, color: Colors.black),
                  const SizedBox(height: 10),
                  Text(
                    usuario!['nombre'],
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _dato('Correo', usuario!['correo']),
                  _dato('Teléfono', usuario!['telefono']),
                  _dato('Edad', '${usuario!['edad']} años'),

                  const SizedBox(height: 30),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: const [
                        Icon(Icons.favorite, color: Colors.red),
                        SizedBox(width: 6),
                        Text('Solicitudes de Adopción', style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (solicitudes.isEmpty)
                    const Text('No hay solicitudes.')
                  else
                    ...solicitudes.map((sol) => _tarjetaSolicitud(sol)),

                  const SizedBox(height: 20),
                  if (mensaje.isNotEmpty)
                    Text(
                      mensaje,
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: 4),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/about'),
        backgroundColor: accentColor,
        child: const Icon(Icons.info_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _dato(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value),
        ],
      ),
    );
  }

  Widget _tarjetaSolicitud(dynamic sol) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            sol['mascota_foto'] ?? 'https://via.placeholder.com/50',
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text('🐾 ${sol['mascota_nombre'] ?? '-'}', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${sol['estado']}'),
            Text('Fecha: ${sol['fecha']?.substring(0, 10) ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}