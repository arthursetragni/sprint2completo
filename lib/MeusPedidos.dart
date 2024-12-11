import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/TelaAvaliacao.dart';
import 'package:login/widgets/barra_nav.dart';
import 'widgets/barra_nav.dart';
import 'widgets/botao_recebe_icon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/User.dart';

class MeusPedidos extends StatefulWidget {
  @override
  _MeusPedidosState createState() => _MeusPedidosState();
}
//página em si
class _MeusPedidosState extends State<MeusPedidos> {
  User? usuario;
  String _baseUrl = "http://localhost:3000";
  //String _baseUrl = "https://backend-lddm.vercel.app";
  List<Map<String, dynamic>> _todosServicos = []; // Lista de todos os serviços
  List<Map<String, dynamic>> _servicosFiltrados = []; // Lista de serviços filtrados por categoria

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarServicosPorUsuario(String idUsuarioLogado) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/servico"));

      // Imprimir a resposta para ver o que está sendo retornado
      print("Resposta do servidor: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('servicos') && data['servicos'] is List) {
          final List<dynamic> servicosDinamicos = data['servicos'];
          final List<Map<String, dynamic>> servicos = servicosDinamicos
              .map((e) => e as Map<String, dynamic>)
              .toList();

          // Filtrando serviços pelo ID do executor (usuário logado)
          setState(() {
            _todosServicos = servicos;
            _servicosFiltrados = servicos
                .where((servico) => servico['id_executor'] == idUsuarioLogado)
                .toList();
          });

          if (_servicosFiltrados.isEmpty) {
            _mostrarMensagem("Nenhum serviço encontrado para este usuário.");
          } else {
            //print("Achou esses:");
            //print(_servicosFiltrados);
            /*
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetalhePedidoEmAndamento(
                  idUsuario: idUsuarioLogado,
                  servicos: _servicosFiltrados,
                ),
              ),
            );
            */
          }
        } else {
          _mostrarMensagem("Nenhum serviço encontrado.");
        }
      } else {
        _mostrarMensagem(jsonDecode(response.body)['msg'] ?? "Erro ao buscar serviços.");
      }
    } catch (e) {
      _mostrarMensagem("Erro ao conectar-se ao servidor.");
    }
  }
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

    @override

    Future<void> _carregarUsuarioLogado() async {
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString("usuario");
      if (usuarioJson != null) {
        setState(() {
          usuario = User.fromJson(jsonDecode(usuarioJson));
          print(usuario!.id);
          _carregarServicosPorUsuario(usuario!.id);
        });
      } else {
        print('Nenhum usuário logado encontrado');
      }
    }

  List<dynamic> jobs = [];
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
    return InkWell(
      onTap: () {
        // Ação ao clicar no card
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detalhes do pedido: ${pedido.titulo}')),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Image.network(pedido.imagem,
              width: 100, height: 110, fit: BoxFit.cover),
          title: Text(pedido.titulo),
          subtitle:
              Text('Funcionário: ${pedido.funcionario}\nData: ${pedido.data}'),
          isThreeLine: true,
        ),
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
    return InkWell(
      onTap: () {
        // Ação ao clicar no card
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Acessando ${pedido.titulo}')),
        );
      },
      child: Card(
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
      ),
    );
  }
  
}

class ApiServices {
  // URL base da API, definida como constante
  static const String baseUrl =
      "http://localhost:3000";

  // Método para gerar a URL de rotas específicas
  static String endpoint(String path) {
    return "$baseUrl$path";
  }
}