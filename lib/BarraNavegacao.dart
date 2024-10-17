import 'package:flutter/material.dart';
import 'BarraPesquisa.dart';
import 'MeusPedidos.dart';
import 'home.dart'; // Importando a página de "Home"
import 'widgets/barra_nav.dart';

class BarraNavegacao extends StatefulWidget {
  @override
  _BarraNavegacaoState createState() => _BarraNavegacaoState();
}

class _BarraNavegacaoState extends State<BarraNavegacao> {
  int currentPageIndex = 1;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      // Local antigo da navigation bar
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
                  childAspectRatio:
                      1.5, // Proporção do card para ter altura menor
                ),
                itemCount:
                    categorias.length, // Número de cards a serem exibidos
                itemBuilder: (context, index) {
                  final Map<String, String> categoria = categorias[index];
                  return Card(
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
                              opacity:
                                  0.6, // Transparência para destacar o texto
                              child: Image.network(
                                categoria['imagem']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        Center(
                          child: Text(
                            categoria['nome']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ),
                      ],
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
final List<Map<String, String>> categorias = [
  {
    'nome': 'Pintor',
    'imagem':
        'https://thumbs.dreamstime.com/z/pintor-que-pinta-uma-parede-com-rolo-de-pintura-70939583.jpg',
  },
  {
    'nome': 'Eletricista',
    'imagem': 'https://thumbs.dreamstime.com/b/eletricista-30694651.jpg',
  },
  {
    'nome': 'Encanador',
    'imagem':
        'https://p2.trrsf.com/image/fget/cf/774/0/images.terra.com/2023/02/13/596680869-super-mario-bros-plumbing-commercial.jpg',
  },
  {
    'nome': 'Jardineiro',
    'imagem':
        'https://st4.depositphotos.com/1203257/27909/i/450/depositphotos_279097904-stock-photo-hedge-trimming-work.jpg',
  },
  {
    'nome': 'Pedreiro',
    'imagem':
        'https://media.istockphoto.com/id/1451138342/pt/foto/construction-mason-worker-bricklayer-installing-red-brick-with-trowel-putty-knife-outdoors.jpg?s=612x612&w=0&k=20&c=B5nDoDVHy-FzaL1q7Eo7Kv7V5VvbclKpZals5VkIGfo=',
  },
  {
    'nome': 'Carpinteiro',
    'imagem':
        'https://www.mundolinhaviva.com.br/blog/wp-content/uploads/2019/07/saiba-quais-epis-mais-importantes-para-carpinteiro-redimensionada.jpg',
  },
];
