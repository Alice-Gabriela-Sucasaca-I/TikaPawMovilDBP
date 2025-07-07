import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List<dynamic> mascotas = [];
  bool cargando = false;
  String? error;

  final Color coral = const Color(0xFFF4A484);
  final Color coralDark = const Color(0xFFE8926E);
  final Color fondoSuave = const Color(0xFFFFF8F5);

  @override
  void initState() {
    super.initState();
    _cargarMascotas();
  }

  Future<void> _cargarMascotas() async {
    setState(() {
      cargando = true;
      error = null;
    });

    try {
      final response = await DioClient.dio.get('/mascotas');
      final data = response.data;

      if (data['success'] == true && data['mascotas'] != null) {
        final lista = List.from(data['mascotas']);
        lista.sort((a, b) => (a['id'] ?? 0).compareTo(b['id'] ?? 0));
        setState(() {
          mascotas = lista.take(5).toList(); // Solo los 5 primeros
        });
      } else {
        setState(() {
          error = data['message'] ?? 'No se encontraron mascotas.';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error al cargar las mascotas.';
      });
    } finally {
      setState(() {
        cargando = false;
      });
    }
  }

  void _verMascota(Map<String, dynamic> mascota) {
    Navigator.pushNamed(context, '/mascotainfosolicitud', arguments: mascota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondoSuave,
      appBar: AppBar(
        title: Text('TikaPaw', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: coral,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/logo.png',
                          height: 90,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Bienvenido a TikaPaw 🐾',
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: coralDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    'Cada patita tiene una historia esperando ser escrita. Dale una segunda oportunidad al amor.',
                    style: GoogleFonts.poppins(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25),
                  Text(
                    '¿Por qué adoptar en TikaPaw?',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '• Amor Incondicional\n• Apoya a Refugios\n• Brindas una segunda oportunidad',
                    style: GoogleFonts.poppins(fontSize: 16, height: 1.6),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Mascotas en adopción',
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),

                  // Tarjetas de mascotas
                  ...mascotas.map((m) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(
                              m['foto'] != null && m['foto'].toString().isNotEmpty
                                  ? 'https://moviltika-production.up.railway.app/uploads/${m['foto']}'
                                  : 'https://via.placeholder.com/300x200.png?text=Mascota',
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['nombre'] ?? 'Sin nombre',
                                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: () => _verMascota(m),
                                  icon: const Icon(Icons.favorite_outline),
                                  label: const Text('Adóptame'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: coralDark,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, '/refugios'),
                      icon: const Icon(Icons.pets),
                      label: const Text('Ver más mascotas'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: coral,
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: GoogleFonts.poppins(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/about'),
        backgroundColor: coral,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
