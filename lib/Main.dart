import 'package:flutter/material.dart';
import 'package:login/Cadastro.dart';
import 'package:login/MeusPedidos.dart';
import 'DetalheServico.dart';
import 'MeuPerfil.dart';
import 'BarraNavegacao.dart';
import 'Login.dart';
import 'home.dart';
import 'PaginaInicial.dart';
import 'DetalhePedidoEmAndamento.dart';
import 'TelaAvaliacao.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const Main(), // Chamando o widget Main como tela inicial
      routes: {
        '/': (context) => const Main(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
        '/Detalhe': (context) => const DetalheServivo(),
        '/cadastro': (context) => const Cadastro(),
        '/pesquisa': (context) => BarraNavegacao(),
        '/meusPedidos': (context) => MeusPedidos(),
        '/meuPerfil': (context) => MeuPerfil(),
        '/paginaInicial': (context) => PaginaInicial(),
        '/DetalheServicoEmAndamento': (context) => DetalheServicoEmAndamento(),
        '/avaliacao': (context) => TelaAvaliacao(),

      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return PaginaInicial();
  }
}
