import 'package:flutter/material.dart';

class BarraNav extends StatefulWidget {
  const BarraNav({super.key});

  @override
  _BarraNavState createState() => _BarraNavState();
}

class _BarraNavState extends State<BarraNav> {
  int _selectedIndex = 0; // Define o índice inicial como 0 (página inicial)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o índice selecionado
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/pesquisa');
        break;
      case 2:
        Navigator.pushNamed(context, '/meusPedidos');
        break;
      case 3:
        Navigator.pushNamed(context, '/meuPerfil');
        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Atualiza o índice selecionado com base na rota atual
    final String currentRoute =
        ModalRoute.of(context)?.settings.name ?? '/home';
    switch (currentRoute) {
      case '/home':
        _selectedIndex = 0;
        break;
      case '/pesquisa':
        _selectedIndex = 1;
        break;
      case '/meusPedidos':
        _selectedIndex = 2;
        break;
      case '/meuPerfil':
        _selectedIndex = 3;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: _selectedIndex, // Define o botão selecionado dinamicamente
      onDestinationSelected: _onItemTapped, // Atualiza o estado ao clicar
      indicatorColor: const Color.fromARGB(155, 255, 61, 61),
      destinations: const <Widget>[
        NavigationDestination(
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
    );
  }
}
