import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/TelaAvaliacao.dart';
import 'package:login/widgets/barra_nav.dart';
import 'widgets/botao_recebe_icon.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/User.dart';

class MeusPedidos extends StatefulWidget {
  @override
  _MeusPedidosState createState() => _MeusPedidosState();
}

class _MeusPedidosState extends State<MeusPedidos> {
  User? usuario;
  String _baseUrl = "http://localhost:3000";
  List<Map<String, dynamic>> _todosServicos = [];
  List<Map<String, dynamic>> _servicosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarServicosPorUsuario(String idUsuarioLogado) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/servico"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('servicos') && data['servicos'] is List) {
          final List<dynamic> servicosDinamicos = data['servicos'];
          final List<Map<String, dynamic>> servicos = servicosDinamicos
              .map((e) => e as Map<String, dynamic>)
              .toList();

          setState(() {
            _todosServicos = servicos;
            _servicosFiltrados = servicos.where((servico) =>
              (servico['id_executor'] == idUsuarioLogado) ||
              (servico['id_criador'] == idUsuarioLogado && servico['id_executor'] != "000000000000000000000000")
            ).toList();
          });
        } else {
          _mostrarMensagem("Nenhum serviço encontrado.");
        }
      } else {
        _mostrarMensagem(
            jsonDecode(response.body)['msg'] ?? "Erro ao buscar serviços.");
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

  Future<void> _carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString("usuario");
    if (usuarioJson != null) {
      setState(() {
        usuario = User.fromJson(jsonDecode(usuarioJson));
        _carregarServicosPorUsuario(usuario!.id);
        //_carregarServicosPorUsuario("6747660577ece4c11fda1818");
      });
    } else {
      print('Nenhum usuário logado encontrado');
    }
  }

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
          backgroundColor: const Color.fromARGB(255, 251, 251, 251),
        ),
        body: TabBarView(
          children: [
            PedidosEmAndamento(pedidosFiltrados: _servicosFiltrados),
            PedidosConcluidos(pedidosConcluidos: _todosServicos),
          ],
        ),
        bottomNavigationBar: const BarraNav(),
      ),
    );
  }
}

// Método para obter o caminho da imagem baseado na categoria
String _getImagePath(int categoria) {
  switch (categoria) {
    case 1:
      return "assets/home/pintor.png";
    case 2:
      return "assets/home/empregada.jpg";
    case 3:
      return "assets/home/eletricista.png";
    case 4:
      return "assets/home/encanador.png";
    default:
      return "assets/home/default.png";
  }
}

// Pedidos em andamento
class PedidosEmAndamento extends StatelessWidget {
  final List<Map<String, dynamic>> pedidosFiltrados;

  PedidosEmAndamento({required this.pedidosFiltrados});

  @override
  Widget build(BuildContext context) {
    return pedidosFiltrados.isEmpty
        ? Center(child: Text("Nenhum serviço em andamento."))
        : ListView.builder(
            itemCount: pedidosFiltrados.length,
            itemBuilder: (context, index) {
              final pedido = pedidosFiltrados[index];
              final String imagePath = _getImagePath(pedido['categoria']);
              return PedidoCardSemIcon(
                pedido: Pedido(
                  imagem: imagePath,
                  titulo: pedido['titulo'],
                  funcionario: pedido['funcionario'] ?? "Não informado",
                  data: pedido['data_criacao'] ?? "Data não especificada",
                ),
              );
            },
          );
  }
}

// Pedidos concluídos
class PedidosConcluidos extends StatelessWidget {
  final List<Map<String, dynamic>> pedidosConcluidos;

  PedidosConcluidos({required this.pedidosConcluidos});

  @override
  Widget build(BuildContext context) {
    return pedidosConcluidos.isEmpty
        ? Center(child: Text("Nenhum serviço concluído."))
        : ListView.builder(
            itemCount: pedidosConcluidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidosConcluidos[index];
              final String imagePath = _getImagePath(pedido['categoria']);
              return PedidoCardComIcon(
                pedido: Pedido(
                  imagem: imagePath,
                  titulo: pedido['titulo'],
                  funcionario: pedido['funcionario'] ?? "Não informado",
                  data: pedido['data'] ?? "Data não especificada",
                ),
              );
            },
          );
  }
}

// Classe Pedido
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

// Card sem ícone
class PedidoCardSemIcon extends StatelessWidget {
  final Pedido pedido;

  PedidoCardSemIcon({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Detalhes do pedido: ${pedido.titulo}')),
        );
      },
      child: Card(
        margin: EdgeInsets.all(10),
        child: ListTile(
          leading: Image.asset(pedido.imagem,
              width: 100, height: 110, fit: BoxFit.cover),
          title: Text(pedido.titulo),
          subtitle:
              Text('Data: ${pedido.data}'),
          isThreeLine: true,
        ),
      ),
    );
  }
}

// Card com ícone
class PedidoCardComIcon extends StatelessWidget {
  final Pedido pedido;

  PedidoCardComIcon({required this.pedido});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
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
              Image.asset(
                pedido.imagem,
                width: 100,
                height: 110,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pedido.titulo,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              BotaoRecebeIcon(
                Icons.star,
                iconColor: Colors.yellow,
                iconSize: 24,
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