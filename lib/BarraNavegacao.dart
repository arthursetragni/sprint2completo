import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'BarraPesquisa.dart';
import 'MeusPedidos.dart';
import 'home.dart';
import 'widgets/barra_nav.dart';
import 'ExibicaoPorCategoria.dart';
/*
class BarraNavegacao extends StatefulWidget {
  @override
  _BarraNavegacaoState createState() => _BarraNavegacaoState();
}

class _BarraNavegacaoState extends State<BarraNavegacao> {
  int currentPageIndex = 1;
  final String _baseUrl = "http://localhost:3000"; // URL base do backend

  /// Método para buscar serviços por número de categoria
  Future<void> _aoPressionarCategoria(String numeroCategoria) async {
    try {
      final response = await http.get(Uri.parse("$_baseUrl/servico/$numeroCategoria"));

      // Imprimir a resposta para ver o que está sendo retornado
      print("Resposta do servidor: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('servicos') && data['servicos'] is List) {
          final List<dynamic> servicosDinamicos = data['servicos'];
          final List<Map<String, dynamic>> servicos = servicosDinamicos
              .map((e) => e as Map<String, dynamic>)
              .toList();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExibicaoPorCategoria(
                nomeCategoria: numeroCategoria,
                servicos: servicos,
              ),
            ),
          );
        } else {
          _mostrarMensagem("Nenhum serviço encontrado para esta categoria.");
        }
      } else {
        _mostrarMensagem(jsonDecode(response.body)['msg'] ?? "Erro ao buscar serviços.");
      }
    } catch (e) {
      _mostrarMensagem("Erro ao conectar-se ao servidor.");
    }
  }

  /// Exibir mensagem de erro ou aviso
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: <Widget>[
        Column(), // Página inicial

        /// Pesquisa com cards de categorias personalizadas
        Column(
          children: [
            BarraPesquisa(), // Chama a barra de pesquisa
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Define o número de colunas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Proporção do card para ter altura menor
                ),
                itemCount: categorias.length, // Número de cards a serem exibidos
                itemBuilder: (context, index) {
                  final Map<String, dynamic> categoria = categorias[index];
                  return InkWell(
                    onTap: () {
                      _aoPressionarCategoria(categoria['numero'].toString());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                          if (categoria.containsKey('imagem') &&
                              categoria['imagem'] != null)
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.6, // Transparência para destacar o texto
                                child: Image.network(
                                  categoria['imagem'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Center(
                            child: Text(
                              categoria['nome'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        /// Página de "Meus Pedidos"
        MeusPedidosPage(), // Chama a página de "Meus Pedidos"

        /// Página de perfil
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'página de perfil',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
      bottomNavigationBar: const BarraNav(),
    );
  }
}

// Lista de categorias com nome e imagem
final List<Map<String, dynamic>> categorias = [
  {
    'nome': 'Pintor',
    'imagem': 'https://thumbs.dreamstime.com/z/pintor-que-pinta-uma-parede-com-rolo-de-pintura-70939583.jpg',
    'numero': 1,
  },
  {
    'nome': 'Eletricista',
    'imagem': 'https://thumbs.dreamstime.com/b/eletricista-30694651.jpg',
    'numero': 3,
  },
  {
    'nome': 'Encanador',
    'imagem': 'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/02/13/596680869-super-mario-bros-plumbing-commercial.jpg',
    'numero': 4,
  },
  {
    'nome': 'Jardineiro',
    'imagem': 'https://st4.depositphotos.com/1203257/27909/i/450/depositphotos_279097904-stock-photo-hedge-trimming-work.jpg',
    'numero': 5,
  },
  {
    'nome': 'Pedreiro',
    'imagem': 'https://media.istockphoto.com/id/1451138342/pt/foto/construction-mason-worker-bricklayer-installing-red-brick-with-trowel-putty-knife-outdoors.jpg?s=612x612&w=0&k=20&c=B5nDoDVHy-FzaL1q7Eo7Kv7V5VvbclKpZals5VkIGfo=',
    'numero': 6,
  },
  {
    'nome': 'Carpinteiro',
    'imagem': 'https://www.mundolinhaviva.com.br/blog/wp-content/uploads/2019/07/saiba-quais-epis-mais-importantes-para-carpinteiro-redimensionada.jpg',
    'numero': 7,
  },
];
*/

//pegando todos
class BarraNavegacao extends StatefulWidget {
  @override
  _BarraNavegacaoState createState() => _BarraNavegacaoState();
}

class _BarraNavegacaoState extends State<BarraNavegacao> {
  int currentPageIndex = 1;
  final String _baseUrl = "http://localhost:3000"; // URL base do backend
  //final String _baseUrl = "https://backend-lddm.vercel.app/";

  List<Map<String, dynamic>> _todosServicos = []; // Lista de todos os serviços
  List<Map<String, dynamic>> _servicosFiltrados = []; // Lista de serviços filtrados por categoria

  /// Método para buscar todos os serviços e filtrar por categoria
  Future<void> _carregarServicosPorCategoria(String numeroCategoria) async {
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

          // Filtrando serviços pela categoria selecionada
          setState(() {
            _todosServicos = servicos;
            // Convertendo numeroCategoria para int e comparando com servico['categoria']
            _servicosFiltrados = servicos
                .where((servico) =>
                    servico['categoria'] == int.parse(numeroCategoria)) 
                .toList();
          });

          if (_servicosFiltrados.isEmpty) {
            _mostrarMensagem("Nenhum serviço encontrado para esta categoria.");
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExibicaoPorCategoria(
                  nomeCategoria: numeroCategoria,
                  servicos: _servicosFiltrados,
                ),
              ),
            );
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


  /// Exibir mensagem de erro ou aviso
  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: <Widget>[
        Column(), // Página inicial

        /// Pesquisa com cards de categorias personalizadas
        Column(
          children: [
            BarraPesquisa(), // Chama a barra de pesquisa
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Define o número de colunas
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.5, // Proporção do card para ter altura menor
                ),
                itemCount: categorias.length, // Número de cards a serem exibidos
                itemBuilder: (context, index) {
                  final Map<String, dynamic> categoria = categorias[index];
                  return InkWell(
                    onTap: () {
                      _carregarServicosPorCategoria(categoria['numero'].toString());
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                            Positioned.fill(
                              child: Opacity(
                                opacity: 0.6, // Transparência para destacar o texto
                                child: Image.network(
                                  categoria['imagem'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          Center(
                            child: Text(
                              categoria['nome'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        /// Página de "Meus Pedidos"
        MeusPedidos(), // Chama a página de "Meus Pedidos"

        /// Página de perfil
        Card(
          shadowColor: Colors.transparent,
          margin: const EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Text(
                'página de perfil',
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
        ),
      ][currentPageIndex],
      bottomNavigationBar: const BarraNav(),
    );
  }
}

// Lista de categorias com nome e imagem
final List<Map<String, dynamic>> categorias = [
  {
    'nome': 'Pintor',
    'imagem': 'https://thumbs.dreamstime.com/z/pintor-que-pinta-uma-parede-com-rolo-de-pintura-70939583.jpg',
    'numero': 1,
  },
  {
    'nome': 'Eletricista',
    'imagem': 'https://thumbs.dreamstime.com/b/eletricista-30694651.jpg',
    'numero': 3,
  },
  {
    'nome': 'Encanador',
    'imagem': 'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/02/13/596680869-super-mario-bros-plumbing-commercial.jpg',
    'numero': 4,
  },
  {
    'nome': 'Jardineiro',
    'imagem': 'https://st4.depositphotos.com/1203257/27909/i/450/depositphotos_279097904-stock-photo-hedge-trimming-work.jpg',
    'numero': 5,
  },
  {
    'nome': 'Pedreiro',
    'imagem': 'https://media.istockphoto.com/id/1451138342/pt/foto/construction-mason-worker-bricklayer-installing-red-brick-with-trowel-putty-knife-outdoors.jpg?s=612x612&w=0&k=20&c=B5nDoDVHy-FzaL1q7Eo7Kv7V5VvbclKpZals5VkIGfo=',
    'numero': 6,
  },
  {
    'nome': 'Carpinteiro',
    'imagem': 'https://www.mundolinhaviva.com.br/blog/wp-content/uploads/2019/07/saiba-quais-epis-mais-importantes-para-carpinteiro-redimensionada.jpg',
    'numero': 7,
  },
];
