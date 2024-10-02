import 'package:flutter/material.dart';

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
      body: 
         Container(
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
                            margin: const EdgeInsets.symmetric(horizontal: 44, vertical: 16),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFFCC3733),
                                  ),
                                  padding: const EdgeInsets.all(21),
                                  child: const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                          height: 250, // Aumentar a altura do carrossel
                          child: PageView(
                            controller: PageController(viewportFraction: 0.5),
                            children: [
                              // Card 1
                              _buildCard("Empregada do...", "R\$ 100,00",
                                  'assets/home/empregada.jpg'),
                              // Card 2
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/Detalhe");
                                },
                                child: _buildCard("Encanador URGEN...",
                                    "R\$ 200,00", 'assets/home/encanador.png'),
                              ),
                              // Card 3
                              _buildCard("Eletricista para...", "R\$ 150,00",
                                  'assets/home/eletricista.png'),
                            ],
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });

          if (index == 1) {
            // Índice para a aba 'Procurar'
            Navigator.pushNamed(context, "/pesquisa");
          }
          if (index == 3) {
            // Índice para a aba 'Procurar'
            Navigator.pushNamed(context, "/meuPerfil");
          }
        },
        indicatorColor: const Color.fromARGB(206, 249, 112, 0),
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Página inicial',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Procurar',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            label: 'Meus pedidos',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Meu perfil',
          ),
        ],
      ),
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
        Text(title, style: const TextStyle(fontSize: 15)),
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
}
