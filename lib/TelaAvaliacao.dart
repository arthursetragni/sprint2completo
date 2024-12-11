import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/avaliacao_service.dart';
import 'models/User.dart';
import 'models/Avaliacao.dart';

class TelaAvaliacao extends StatefulWidget {
  @override
  _TelaAvaliacaoState createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  int _avaliacaoSelecionada = 0;
  final TextEditingController _comentarioController = TextEditingController();
  User? usuario;
  Avaliacao? avaliacaoExistente;
  //final AvaliacaoService _avaliacaoService = AvaliacaoService("http://localhost:3000/");
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
        print(usuario!.id);
        _carregarAvaliacoesFiltradas();
      });
    } else {
      print('Nenhum usuário logado encontrado');
    }
  }

  Future<void> _carregarAvaliacoesFiltradas() async {
    if (usuario == null) return;

    try {
      final response = await _avaliacaoService.listarAvaliacoes('avaliacao');
      
      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody.containsKey('avaliacoes') && responseBody['avaliacoes'] is List) {
          final List<dynamic> avaliacaoListJson = responseBody['avaliacoes'];

          List<Avaliacao> avaliacoes = avaliacaoListJson.map((json) => Avaliacao.fromJson(json)).toList();

          final avaliacoesFiltradas = avaliacoes.where((avaliacao) {
            return avaliacao.ID_Avaliador == usuario!.id && avaliacao.ID_Avaliado == '670e9f8ee6657b99823ce0f5'; // Modifique o ID_Avaliado conforme necessário
          }).toList();

          setState(() {
            if (avaliacoesFiltradas.isNotEmpty) {
              avaliacaoExistente = avaliacoesFiltradas.first;
              _avaliacaoSelecionada = avaliacaoExistente!.nota ?? 0;
              _comentarioController.text = avaliacaoExistente!.comentario ?? '';
            } else {
              print('Nenhuma avaliação encontrada para o usuário e serviço especificados');
              _avaliacaoSelecionada = 0;
              _comentarioController.clear();
            }
          });
        } else {
          print('Erro: Resposta não contém a chave "avaliacoes" ou a chave não é uma lista.');
        }
      } else {
        print('Erro ao listar as avaliações: ${response.statusCode}');
      }
    } catch (e) {
      print('Erro ao carregar avaliações filtradas: $e');
    }
  }

  Future<void> _salvarAvaliacao() async {
    if (usuario == null) {
      _mostrarMensagem('Erro', 'Usuário não encontrado. Faça login novamente.', false);
      return;
    }

    if (_avaliacaoSelecionada == 0) {
      _mostrarMensagem('Erro', 'Selecione uma nota antes de enviar.', false);
      return;
    }

    final data = {
      "ID_Avaliado": "670e9f8ee6657b99823ce0f5", // Modifique conforme necessário
      "ID_Avaliador": usuario!.id,
      "ID_Servico": "670e9f8ee6657b99823ce0f5", // Modifique conforme necessário
      "comentario": _comentarioController.text,
      "nota": _avaliacaoSelecionada,
      "data": DateTime.now().toIso8601String(),
    };

    try {
      if (avaliacaoExistente != null) {
        final response = await _avaliacaoService.atualizarAvaliacao('avaliacao', avaliacaoExistente!.id, data);

        if (response.statusCode >= 200 && response.statusCode < 300) {
          setState(() {
            avaliacaoExistente!.comentario = _comentarioController.text;
            avaliacaoExistente!.nota = _avaliacaoSelecionada;
          });

          _mostrarMensagem('Sucesso', 'Avaliação atualizada com sucesso!', true);
        } else {
          _mostrarMensagem('Erro', 'Erro ao atualizar avaliação!', false);
        }
      } else {
        final response = await _avaliacaoService.criaAvaliacao('avaliacao', data);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          _mostrarMensagem('Sucesso', 'Avaliação enviada com sucesso!', true);
        } else {
          _mostrarMensagem('Erro', 'Erro ao salvar avaliação!', false);
        }
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
        setState(() {
          avaliacaoExistente = null;
          _avaliacaoSelecionada = 0;
          _comentarioController.clear();
        });
      } else {
        _mostrarMensagem('Erro', 'Não foi possível excluir a avaliação. Código: ${response.statusCode}', false);
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                  Navigator.pop(context);
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
                Navigator.of(context).pop();
              },
              child: Text('CANCELAR'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (avaliacaoExistente != null) {
                  _excluirAvaliacao(avaliacaoExistente!.id);
                }
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
                hintText: avaliacaoExistente != null
                    ? 'Atualize seu comentário...'
                    : 'Conte-nos o que achou do serviço...',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: avaliacaoExistente != null
          ? Container(
              width: 60, 
              height: 60,
              child: FloatingActionButton(
                onPressed: _confirmarExclusao,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                tooltip: 'Excluir Avaliação',
              ),
            )
          : null,
    );
  }
}

