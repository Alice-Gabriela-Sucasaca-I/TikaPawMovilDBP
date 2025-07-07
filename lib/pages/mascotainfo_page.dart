import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../helpers/dio_client.dart';

class MascotaInfoPage extends StatefulWidget {
  final Map<String, dynamic> mascota;

  const MascotaInfoPage({super.key, required this.mascota});

  @override
  State<MascotaInfoPage> createState() => _MascotaInfoPageState();
}

class _MascotaInfoPageState extends State<MascotaInfoPage> {
  List<dynamic> solicitudes = [];
  String mensaje = '';
  bool cargando = true;

  final Color coral = const Color(0xFFF4A484);
  final Color coralDark = const Color(0xFFE8926E);
  final Color fondoSuave = Colors.white;

  @override
  void initState() {
    super.initState();
    cargarSolicitudes();
  }

  Future<void> cargarSolicitudes() async {
    try {
      final response = await DioClient.dio.get(
        '/solicitudes/mascota/${widget.mascota['idmascota']}',
        options: Options(validateStatus: (status) => status != null && status < 500),
      );

      if (!mounted) return;

      if (response.statusCode == 404) {
        setState(() => solicitudes = []);
      } else if (response.data['success'] == true) {
        setState(() => solicitudes = response.data['solicitudes']);
      } else {
        setState(() => mensaje = response.data['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => mensaje = 'Error al cargar solicitudes: $e');
    } finally {
      if (!mounted) return;
      setState(() => cargando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final m = widget.mascota;

    final fotoUrl = m['foto'] != null && m['foto'].toString().isNotEmpty
        ? 'https://moviltika-production.up.railway.app/uploads/${m['foto']}'
        : 'https://via.placeholder.com/220';

    return Scaffold(
      backgroundColor: fondoSuave,
      appBar: AppBar(
        title: Text('Mascota: ${m['nombre']}'),
        backgroundColor: coral,
        foregroundColor: Colors.white,
        elevation: 3,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    fotoUrl,
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(height: 30),
            _infoItem('📝 Nombre', m['nombre']),
            _infoItem('🎂 Edad', '${m['edad']} años'),
            _infoItem('🐾 Especie', m['especie']),
            _infoItem('⚧ Género', m['genero']),
            _infoItem('📏 Tamaño', m['tamanio']),
            const SizedBox(height: 20),
            const Text(
              '🗒️ Descripción',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              m['descripcion'] ?? '-',
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 40),
            const Text(
              '📬 Solicitudes de Adopción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (cargando)
              const Center(child: CircularProgressIndicator())
            else if (solicitudes.isEmpty)
              const Text('No hay solicitudes registradas.',
                  style: TextStyle(color: Colors.grey))
            else
              Column(
                children: solicitudes.map((s) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.account_circle_rounded,
                          size: 40, color: Color(0xFFEC8C68)),
                      title: Text('Estado: ${s['estado']}',
                          style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        'Fecha: ${s['fecha']?.substring(0, 10) ?? 'N/A'}',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              ),
            if (mensaje.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  mensaje,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 40),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/refugio');
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al perfil del refugio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: coralDark,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
