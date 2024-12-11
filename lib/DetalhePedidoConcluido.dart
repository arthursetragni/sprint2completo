import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class DetalheServicoConcluido extends StatefulWidget {
  const DetalheServicoConcluido({super.key});

  @override
  _DetalheServicoConcluidoState createState() => _DetalheServicoConcluidoState();
}

class _DetalheServicoConcluidoState extends State<DetalheServicoConcluido> {
  int currentPageIndex = 0;
  //String _baseUrl = "http://localhost:3000";
  String _baseUrl = "https://backend-lddm.vercel.app";
  List<Map<String, dynamic>> _todosServicos = [];
  Map<String, dynamic>? job;

  @override
  void initState() {
    super.initState();
    _carregarServicos();
  }

  Future<void> _carregarServicos() async {
    try {
      setState(() {
        _todosServicos = []; // Exibe tela de carregamento
      });
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

  Future<void> _concluirServico(String idServico) async {
    try {
      final response = await http.patch(
        Uri.parse("$_baseUrl/servico/$idServico"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"tipo": "concluido"}),
      );

      if (response.statusCode == 200) {
        _mostrarMensagem("Serviço concluído com sucesso.");
        setState(() {
          job!['tipo'] = "concluido";
        });
      } else {
        _mostrarMensagem("Erro ao concluir o serviço: ${response.body}");
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
  Widget build(BuildContext context) {
    final String trabalhoId = ModalRoute.of(context)!.settings.arguments as String;

    if (_todosServicos.isNotEmpty) {
      job = _todosServicos.firstWhere((element) => element['_id'] == trabalhoId, orElse: () => {});
    }

    if (job == {}) {
      return Scaffold(
        appBar: AppBar(title: const Text("Carregando...")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

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
                          child: Text(
                            job!['titulo'], // Exibe o título do trabalho
                            style: const TextStyle(
                              color: Color(0xFF4F4F4F),
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
                          margin: const EdgeInsets.only(bottom: 26, left: 54, right: 54),
                          width: double.infinity,
                          child: Text(
                            job!['descricao'], // Exibe a descrição do trabalho
                            style: const TextStyle(
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
                          child: Text(
                            "R\$ ${job!['preco_acordado']}", // Exibe o preço do trabalho
                            style: const TextStyle(
                              color: Color(0xFF27AE60),
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
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

