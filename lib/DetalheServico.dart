import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const DetalheServivo(),
//     );
//   }
// }

class DetalheServivo extends StatefulWidget {
  const DetalheServivo({super.key});

  @override
  _DetalheServivoState createState() => _DetalheServivoState();
}

class _DetalheServivoState extends State<DetalheServivo> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  color: const Color(0xFFFFFFFF),
                  width: double.infinity,
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 48),
                          height: 194,
                          width: double.infinity,
                          child: Image.network(
                            "https://i.imgur.com/1tMFzp8.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 32, left: 54),
                          child: const Text(
                            "Titúlo do trabalho",
                            style: TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 57, left: 54, right: 54),
                          width: double.infinity,
                          child: const Text(
                            "Encanador URGENTE para consertar meu cano",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 30, left: 53),
                          child: const Text(
                            "Descrição",
                            style: TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              bottom: 26, left: 54, right: 54),
                          width: double.infinity,
                          child: const Text(
                            "Estamos à procura de um encanador experiente para realizar reparos e manutenção em nosso sistema hidráulico.",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 18, left: 53),
                          child: const Text(
                            "Preço",
                            style: TextStyle(
                              color: Color(0xFF4F4F4F),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 68, left: 53),
                          child: const Text(
                            "R\$ 200.00",
                            style: TextStyle(
                              color: Color(0xFF27AE60),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IntrinsicHeight(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color(0xFFCC3733),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 17),
                            margin: const EdgeInsets.only(
                                bottom: 145, left: 145, right: 145),
                            width: double.infinity,
                            child: const Column(
                              children: [
                                Text(
                                  "Inscrever-se",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
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
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
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
}
