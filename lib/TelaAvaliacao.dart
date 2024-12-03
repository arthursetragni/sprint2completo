import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/botao_recebe_icon.dart';
import 'services/avaliacao_service.dart';
import 'models/User.dart';

class TelaAvaliacao extends StatefulWidget {
  @override
  _TelaAvaliacaoState createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  int _avaliacaoSelecionada = 0;
  final TextEditingController _comentarioController = TextEditingController();
  User? usuario;
  final AvaliacaoService _avaliacaoService = AvaliacaoService("https://backend-lddm.vercel.app/");

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString("usuario");
    if (usuarioJson != null) {
      setState(() {
        usuario = User.fromJson(jsonDecode(usuarioJson));
      });
    } else {
      print('Nenhum usuário logado encontrado');
    }
  }

  Future<void> _salvarAvaliacao() async {
    if (usuario == null) {
      print('Usuário não encontrado. Faça login novamente.');
      return;
    }

    if (_avaliacaoSelecionada == 0) {
      print('Avaliação obrigatória');
      return;
    }

    final data = {
      "idAvaliador": "670e9f8ee6657b99823ce0f5",
      "idAvaliado": "670e9f8ee6657b99823ce0f5",
      "idServico": "67325e8cdba63ef7c5e4c31e",
      "data": DateTime.now().toIso8601String(),
      "nota": _avaliacaoSelecionada,
      "comentario": _comentarioController.text,
    };

    try {
      final response = await _avaliacaoService.conexaoPost('avaliacao', data);
      if (response.statusCode == 201) {
        print("Avaliação salva com sucesso!");
        Navigator.pop(context);
      } else {
        print("Erro ao salvar avaliação: \${response.body}");
      }
    } catch (e) {
      print("Exceção ao salvar avaliação: \${e}");
    }
  }

  void _selecionarAvaliacao(int indice) {
    setState(() {
      _avaliacaoSelecionada = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Avaliação'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _salvarAvaliacao,
            child: Text(
              'Postar',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Estrelas de Avaliação
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    Icons.star,
                    color: index < _avaliacaoSelecionada
                        ? Colors.yellow
                        : Colors.grey,
                    size: 40,
                  ),
                  onPressed: () => _selecionarAvaliacao(index + 1),
                );
              }),
            ),

            const SizedBox(height: 20),

            // Campo de Comentário
            TextField(
              controller: _comentarioController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Conte-nos o que achou do serviço...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // Botão de Adicionar Fotos
            ElevatedButton.icon(
              onPressed: () {
                print("Funcionalidade de adicionar imagens ainda não implementada.");
              },
              icon: Icon(Icons.photo_camera),
              label: Text('Adicionar fotos'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.red,
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


