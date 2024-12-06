import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final AvaliacaoService _avaliacaoService =
      AvaliacaoService("https://backend-lddm.vercel.app/");
  String idAvaliacao = "67325e8cdba63ef7c5e4c31e"; // Substitua pelo ID real.

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
      _mostrarMensagem(
          'Erro', 'Usuário não encontrado. Faça login novamente.', false);
      return;
    }

    if (_avaliacaoSelecionada == 0) {
      _mostrarMensagem('Erro', 'Selecione uma nota antes de enviar.', false);
      return;
    }

    final data = {
      "idAvaliador": "670e9f8ee6657b99823ce0f5",
      "idAvaliado": "670e9f8ee6657b99823ce0f5",
      "idServico": idAvaliacao,
      "data": DateTime.now().toIso8601String(),
      "nota": _avaliacaoSelecionada,
      "comentario": _comentarioController.text,
    };

    try {
      final response = await _avaliacaoService.conexaoPost('avaliacao', data);
      if (response.statusCode == 201) {
        _mostrarMensagem('Sucesso', 'Avaliação enviada com sucesso!', true);
      } else {
        _mostrarMensagem('Erro', 'Erro ao salvar avaliação!', false);
      }
    } catch (e) {
      _mostrarMensagem('Erro', 'Exceção ao salvar avaliação: $e', false);
    }
  }

  Future<void> _excluirAvaliacao(String id) async {
    if (id.isEmpty) {
      _mostrarMensagem('Erro', 'Avaliação não encontrada!', false);
      return;
    }

    try {
      final response = await _avaliacaoService.deletarAvaliacao('avaliacao', id);
      if (response.statusCode == 200) {
        _mostrarMensagem('Sucesso', 'Avaliação excluída com sucesso.', true);
      } else {
        _mostrarMensagem(
          'Erro',
          'Não foi possível excluir a avaliação. Código: ${response.statusCode}',
          false,
        );
      }
    } catch (e) {
      _mostrarMensagem('Erro', 'Erro ao excluir avaliação: $e', false);
    }
  }

  void _mostrarMensagem(String titulo, String mensagem, bool sucesso) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Row(
            children: [
              Icon(
                sucesso ? Icons.check_circle : Icons.error,
                color: sucesso ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 10),
              Text(titulo),
            ],
          ),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (sucesso) {
                  Navigator.pop(context); // Fecha a tela de avaliação em caso de sucesso
                }
              },
              child: Text('FECHAR'),
            ),
          ],
        );
      },
    );
  }

  void _selecionarAvaliacao(int indice) {
    setState(() {
      _avaliacaoSelecionada = indice;
    });
  }

  void _confirmarExclusao() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text('Confirmação'),
          content: Text('Tem certeza de que deseja excluir esta avaliação?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
                _excluirAvaliacao(idAvaliacao); // Chama o método de exclusão
              },
              child: Text('EXCLUIR'),
            ),
          ],
        );
      },
    );
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
              style: TextStyle(color: Colors.green, fontSize: 16),
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
                print(
                    "Funcionalidade de adicionar imagens ainda não implementada.");
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
      floatingActionButton: Container(
        width: 60, // Tamanho do botão
        height: 60,
        child: FloatingActionButton(
          onPressed: _confirmarExclusao,
          backgroundColor: Colors.white, // Fundo branco
          child: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          tooltip: 'Excluir Avaliação',
        ),
      ),
    );
  }
}
