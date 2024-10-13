import 'package:flutter/material.dart';
import 'package:login/widgets/barra_nav.dart';
import 'widgets/barra_nav.dart';

class MeusPedidosPage extends StatefulWidget {
  @override
  _MeusPedidosPageState createState() => _MeusPedidosPageState();
}

class _MeusPedidosPageState extends State<MeusPedidosPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 244, 64, 3), // Cor de fundo
                borderRadius: BorderRadius.circular(20), // Bordas arredondadas
              ),
              child: Text(
                'Meus Pedidos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Em Andamento'),
              Tab(text: 'Concluídos'),
            ],
          ),
          backgroundColor: const Color.fromARGB(
              255, 251, 251, 251), // Ajuste do fundo da AppBar para combinar
        ),
        body: TabBarView(
          children: [
            PedidosEmAndamento(),
            PedidosConcluidos(),
          ],
        ),
        bottomNavigationBar: const BarraNav(),
      ),
    );
  }
}

class PedidosEmAndamento extends StatelessWidget {
  final List<Pedido> pedidos = [
    Pedido(
        imagem: 'assets/imagem_servico1.jpg',
        titulo: 'Limpeza de Jardim',
        funcionario: 'Carlos Silva',
        data: '01/10/2024'),
    Pedido(
        imagem: 'assets/imagem_servico2.jpg',
        titulo: 'Reparação Elétrica',
        funcionario: 'Ana Souza',
        data: '28/09/2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return PedidoCard(pedido: pedidos[index]);
      },
    );
  }
}

class PedidosConcluidos extends StatelessWidget {
  final List<Pedido> pedidos = [
    Pedido(
        imagem: 'assets/imagem_servico3.jpg',
        titulo: 'Pintura Residencial',
        funcionario: 'João Pedro',
        data: '25/09/2024'),
    Pedido(
        imagem: 'assets/imagem_servico4.jpg',
        titulo: 'Instalação de Ar-condicionado',
        funcionario: 'Maria Clara',
        data: '20/09/2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return PedidoCard(pedido: pedidos[index]);
      },
    );
  }
}

class Pedido {
  final String imagem;
  final String titulo;
  final String funcionario;
  final String data;

  Pedido({
    required this.imagem,
    required this.titulo,
    required this.funcionario,
    required this.data,
  });
}

class PedidoCard extends StatelessWidget {
  final Pedido pedido;

  PedidoCard({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.asset(pedido.imagem,
            width: 50, height: 50, fit: BoxFit.cover),
        title: Text(pedido.titulo),
        subtitle:
            Text('Funcionário: ${pedido.funcionario}\nData: ${pedido.data}'),
        isThreeLine: true,
      ),
    );
  }
}
