import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'widgets/barra_nav.dart';
import 'post_job.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        color: const Color(0xFFFFFFFF),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cabeçalho
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 54, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Home",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Seção de ofertas
                      Center(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 44, vertical: 16),
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              InkWell(
                                onTap: () {
                                  // Coloque aqui a ação que deve ocorrer ao clicar
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const PostJob()),
                                  );
                                  print("Container clicado!");
                                },
                                borderRadius: BorderRadius.circular(
                                    15), // Para combinar com o formato do Container
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFFCC3733),
                                  ),
                                  padding: const EdgeInsets.all(21),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Crie seu Portfólio",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "Finalize seu perfil antes de prosseguir",
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 64,
                                left: 14,
                                right: 14,
                                child: Container(
                                  height: 89,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0x66CC3733),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Seção "Top da semana"
                      const SizedBox(
                          height:
                              100), // Adiciona espaço antes do título "Top da semana"
                      Container(
                        margin: const EdgeInsets.only(bottom: 34, left: 16),
                        child: const Text(
                          "Top da semana",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Cards em linha para "Top da semana"
                      SizedBox(
                        height: 250,
                        child: PageView(
                          controller: PageController(viewportFraction: 0.5),
                          children: jobs.map((job) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "/Detalhe",
                                    arguments: job['id']);
                              },
                              child: _buildCard(
                                job['titulo'],
                                "R\$ ${job['preco']}",
                                job['imagem'],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BarraNav(),
    );
  }

  // Método auxiliar para construir os cards
  Widget _buildCard(String title, String price, String imagePath) {
    return Column(
      children: [
        Container(
          width: 147,
          height: 190,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFF4F4F4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.fill,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0), // Adiciona padding horizontal
          child: Text(
            title,
            style: const TextStyle(fontSize: 15),
            overflow:
                TextOverflow.ellipsis, // Adiciona o tratamento de overflow
            maxLines: 1, // Limita a uma linha
          ),
        ),
        const SizedBox(height: 3),
        Text(
          price,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Future<List<dynamic>> _loadJobs() async {
    String jsonString = await rootBundle.loadString('assets/json/jobs.json');
    List<dynamic> jobs = json.decode(jsonString);
    return jobs;
  }

  List<dynamic> jobs = [];

  @override
  void initState() {
    super.initState();
    _loadJobs().then((data) {
      setState(() {
        jobs = data;
      });
    });
  }
}
