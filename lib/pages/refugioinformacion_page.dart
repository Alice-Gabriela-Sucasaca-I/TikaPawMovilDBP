import 'package:flutter/material.dart';
import '../helpers/dio_client.dart';
import 'package:url_launcher/url_launcher.dart';

class RefugioInformacionPage extends StatefulWidget {
  final Map<String, dynamic> refugio;

  const RefugioInformacionPage({super.key, required this.refugio});

  @override
  State<RefugioInformacionPage> createState() => _RefugioInformacionPageState();
}

class _RefugioInformacionPageState extends State<RefugioInformacionPage> {
  List<dynamic> mascotas = [];
  bool cargando = true;
  String mensaje = '';

  final Color baseColor = const Color(0xFFF2BA9D);
  final Color secondaryColor = const Color(0xFFEC8C68);
  final Color accentColor = const Color(0xFFF88064);

  @override
  void initState() {
    super.initState();
    cargarMascotas();
  }

  Future<void> cargarMascotas() async {
    try {
      final response = await DioClient.dio
          .get('/refugios/mascotas/${widget.refugio['idcentro']}');
      if (response.data['success'] == true) {
        setState(() {
          mascotas = response.data['mascotas'];
          cargando = false;
        });
      } else {
        setState(() {
          mensaje = 'No se pudieron cargar las mascotas';
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        mensaje = 'Error al cargar mascotas: $e';
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final refugio = widget.refugio;

    return Scaffold(
      //backgroundColor: baseColor.withOpacity(0.05),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Refugio: ${refugio['nombrecentro']}'),
        backgroundColor: secondaryColor,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.home_work_rounded, size: 80, color: Color(0xFFEC8C68)),
                      const SizedBox(height: 12),
                      Text(
                        refugio['nombrecentro'] ?? '',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Encargado: ${refugio['nombreencargado']}',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                _seccionTitulo('📞 Contacto'),
                _dato('Correo', refugio['correo']),
                _dato('Teléfono', refugio['telefono']),
                _dato('Redes', refugio['redesociales'] ?? 'No disponible'),

                const SizedBox(height: 24),

                _seccionTitulo('🐾 Mascotas en este Refugio'),
                if (mensaje.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(mensaje, style: const TextStyle(color: Colors.red)),
                  ),
                if (mascotas.isEmpty)
                  const Text('No hay mascotas registradas.')
                else
                  ...mascotas.map((m) => _tarjetaMascota(m)),

                const SizedBox(height: 30),

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                  label: const Text('Volver'),
                ),
                const SizedBox(height: 15),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: secondaryColor,
                    side: BorderSide(color: secondaryColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  icon: const Icon(Icons.language),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Abrir página web"),
                        content: const Text("¿Deseas visitar la página web del refugio?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              final uri = Uri.parse('https://tikapawdbp-48n3.onrender.com/');
                              if (!await launchUrl(uri)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("No se pudo abrir el navegador")),
                                );
                              }
                            },
                            child: const Text("Visitar sitio"),
                          ),
                        ],
                      ),
                    );
                  },
                  label: const Text('Visitar página web'),
                ),
              ],
            ),
    );
  }

  Widget _seccionTitulo(String texto) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        texto,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: secondaryColor,
        ),
      ),
    );
  }

  Widget _dato(String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(valor)),
        ],
      ),
    );
  }

  Widget _tarjetaMascota(dynamic m) {
    final fotoUrl = m['foto'] != null
        ? 'https://moviltika-production.up.railway.app/uploads/${m['foto']}'
        : null;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: fotoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  fotoUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(Icons.pets, size: 40),
        title: Text(m['nombre'] ?? 'Sin nombre', style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${m['especie']} - ${m['edad']} años'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.pushNamed(
          context,
          '/mascotainfosolicitud',
          arguments: m,
        ),
      ),
    );
  }
}
