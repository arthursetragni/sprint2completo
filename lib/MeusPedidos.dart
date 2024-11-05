import 'package:flutter/material.dart';
import 'package:login/TelaAvaliacao.dart';
import 'package:login/widgets/barra_nav.dart';
import 'widgets/barra_nav.dart';
import 'widgets/botao_recebe_icon.dart';

class MeusPedidosPage extends StatefulWidget {
  @override
  _MeusPedidosPageState createState() => _MeusPedidosPageState();
}

//página em si
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
              child: Text(
                'Meus Pedidos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
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
              255, 251, 251, 251), 
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

//área dos pedidos em andamento
class PedidosEmAndamento extends StatelessWidget {
  final List<Pedido> pedidos = [
    Pedido(
        imagem:
            'https://st4.depositphotos.com/1203257/27909/i/450/depositphotos_279097904-stock-photo-hedge-trimming-work.jpg',
        titulo: 'Limpeza de Jardim',
        funcionario: 'Carlos Silva',
        data: '01/10/2024'),
    Pedido(
        imagem: 'https://thumbs.dreamstime.com/b/eletricista-30694651.jpg',
        titulo: 'Reparação Elétrica',
        funcionario: 'Ana Souza',
        data: '28/09/2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return PedidoCardSemIcon(pedido: pedidos[index]);
      },
    );
  }
}

//área dos pedidos concluídos
class PedidosConcluidos extends StatelessWidget {
  final List<Pedido> pedidos = [
    Pedido(
        imagem:
            'https://thumbs.dreamstime.com/z/pintor-que-pinta-uma-parede-com-rolo-de-pintura-70939583.jpg',
        titulo: 'Pintura Residencial',
        funcionario: 'João Pedro',
        data: '25/09/2024'),
    Pedido(
        imagem:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlIk-WqYKq3v4FvTYuPGsrhNPQ2QAMmCtARw&s',
        titulo: 'Instalação de Ar-condicionado',
        funcionario: 'Maria Clara',
        data: '20/09/2024'),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pedidos.length,
      itemBuilder: (context, index) {
        return PedidoCardComIcon(pedido: pedidos[index]);
      },
    );
  }
}

//classe pedido
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

//card sem estrela
class PedidoCardSemIcon extends StatelessWidget {
  final Pedido pedido;

  PedidoCardSemIcon({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Image.network(pedido.imagem,
            width: 100, height: 110, fit: BoxFit.cover),
        title: Text(pedido.titulo),
        subtitle:
            Text('Funcionário: ${pedido.funcionario}\nData: ${pedido.data}'),
        isThreeLine: true,
      ),
    );
  }
}

//a partir daqui card com a estrela
class PedidoCardComIcon extends StatelessWidget {
  final Pedido pedido;

  PedidoCardComIcon({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Imagem do pedido
            Image.network(
              pedido.imagem,
              width: 100,
              height: 110,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10), // Espaço entre a imagem e o conteúdo
            // Informações do pedido e o botão de avaliação lado a lado
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pedido.titulo,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Funcionário: ${pedido.funcionario}',
                    style: TextStyle(fontSize: 14),
                  ),
                  Text(
                    'Data: ${pedido.data}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            // Botão de avaliar ao lado do texto
            BotaoRecebeIcon(
              Icons.star, iconColor: Colors.yellow, iconSize: 24,
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaAvaliacao()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

