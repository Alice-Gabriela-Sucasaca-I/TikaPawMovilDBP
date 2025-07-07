import 'package:flutter/material.dart';
import '../helpers/dio_client.dart';
import '../widgets/tiki_navbar.dart';
import 'refugioinformacion_page.dart';

class RefugiosPage extends StatefulWidget {
  const RefugiosPage({super.key});

  @override
  State<RefugiosPage> createState() => _RefugiosPageState();
}

class _RefugiosPageState extends State<RefugiosPage> {
  List<dynamic> refugios = [];
  bool cargando = true;
  String mensaje = '';

  final Color baseColor = const Color(0xFFF2BA9D);
  final Color secondaryColor = const Color(0xFFEC8C68);
  final Color accentColor = const Color(0xFFF88064);

  @override
  void initState() {
    super.initState();
    cargarRefugios();
  }

  Future<void> cargarRefugios() async {
    try {
      final response = await DioClient.dio.get('/refugios/refugios');
      if (response.data['success'] == true && mounted) {
        setState(() {
          refugios = response.data['refugios'];
        });
      } else {
        setState(() {
          mensaje = 'No se pudieron cargar los refugios.';
        });
      }
    } catch (e) {
      setState(() {
        mensaje = 'Error al cargar refugios: $e';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Refugios'),
        centerTitle: true,
        elevation: 4,
        foregroundColor: Colors.white,
      ),
      body: cargando
          ? const Center(child: CircularProgressIndicator())
          : refugios.isEmpty
              ? Center(
                  child: Text(
                    mensaje.isNotEmpty ? mensaje : 'No hay refugios disponibles.',
                    style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: refugios.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, index) {
                      final refugio = refugios[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RefugioInformacionPage(refugio: refugio),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
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
                                child: Image.asset(
                                  'assets/cat.jpeg',
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        refugio['nombrecentro'] ?? 'Sin nombre',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Encargado: ${refugio['nombreencargado'] ?? 'N/A'}',
                                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: const TikiNavBar(selectedIndex: 1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/about');
        },
        backgroundColor: secondaryColor,
        child: const Icon(Icons.info_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
