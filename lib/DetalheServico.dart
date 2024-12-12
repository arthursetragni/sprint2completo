import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // para acessar SharedPreferences
import 'models/User.dart';


class DetalheServivo extends StatefulWidget {
  const DetalheServivo({super.key});

  @override
  _DetalheServivoState createState() => _DetalheServivoState();
}

class _DetalheServivoState extends State<DetalheServivo> {
  int currentPageIndex = 0;
  List<dynamic> jobs = [];
  Map<String, dynamic>? job; // Modificado para um Map para trabalhar com chaves como 'titulo'
  
  @override

  void _inscreverUsuario(String trabalhoId) async {
    try {
      // Recupera o ID do usuário do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString("usuario");

      if (usuarioJson != null) {
        final user = User.fromJson(jsonDecode(usuarioJson));
        final userId = user.id;

        // Prepara o corpo da requisição
        final body = jsonEncode({
          "id": trabalhoId,
          "id_executor": userId,
        });

        // Faz a requisição POST para o back-end
        final response = await http.post(
          Uri.parse(ApiServices.endpoint("/servico/inscrever")),
          headers: {"Content-Type": "application/json"},
          body: body,
        );

        // Verifica a resposta do servidor
        if (response.statusCode == 200) {
          // Exibe um alerta de sucesso
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Sucesso"),
                content: const Text("Você se inscreveu com sucesso!"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        } else {
          // Trata erros da API
          throw Exception("Erro ao se inscrever: ${response.body}");
        }
      } else {
        throw Exception("Usuário não encontrado no SharedPreferences.");
      }
    } catch (e) {
      // Exibe um alerta de erro
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Erro"),
            content: Text("Falha ao se inscrever: $e"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }


  Future<List<dynamic>> _loadJobs(String trabalhoId) async {
    print(trabalhoId);

    try {
      final response = await http.get(Uri.parse(ApiServices.endpoint("/servico/$trabalhoId")));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['servico'] != null) {
          // Retorna o serviço dentro de uma lista
          return [data['servico']];
        } else {
          throw Exception('Serviço não encontrado no backend.');
        }
      } else {
        throw Exception('Erro ao carregar os serviços. Código: ${response.statusCode}');
      }
    } catch (e) {
      print("Erro: $e");
      throw Exception('Erro ao carregar os serviços.');
    }
  }


  @override
  Widget build(BuildContext context) {
    final String trabalhoId = ModalRoute.of(context)!.settings.arguments as String;

    print(trabalhoId);

     if (jobs.isEmpty) {
      _loadJobs(trabalhoId).then((data) {
        setState(() {
          jobs = data;
        });
      });
    }

    // Verifica se os trabalhos já foram carregados e busca o trabalho correto
    if (jobs.isNotEmpty) {
      for (int i = 0; i < jobs.length; i++) {
        if (jobs[i]['_id'] == trabalhoId) {
          job = jobs[i];
          break;
        }
      }
    }

    // Retorna um layout de carregamento se o job não for encontrado ainda
    if (job == null) {
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
                        IntrinsicHeight(
                          child: GestureDetector(
                            onTap: () {
                              _inscreverUsuario(trabalhoId);
                            },
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

class ApiServices {
  // URL base da API, definida como constante
  static const String baseUrl = "https://backend-lddm.vercel.app";

  // Método para gerar a URL de rotas específicas
  static String endpoint(String path) {
    return "$baseUrl$path";
  }
}
