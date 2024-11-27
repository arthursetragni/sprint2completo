import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widgets/botao_recebe_icon.dart';
import 'widgets/botao_cor_tamanho.dart';
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

    if (_avaliacaoSelecionada == 0 || _comentarioController.text.isEmpty) {
      print('Avaliação e comentário são obrigatórios.');
      return;
    }

    final data = {
      "idAvaliador": usuario!.id, // ID do usuário logado
      "idAvaliado": 1, 
      "idServico": 2, 
      "data": DateTime.now().toIso8601String(),
      "nota": _avaliacaoSelecionada,
      "comentario": _comentarioController.text,
    };

    try {
      final response = await _avaliacaoService.conexaoPost('/avaliacoes', data);
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Título
            Column(
              children: [
                Text(
                  'Avalie o serviço',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Divider(color: Colors.black, thickness: 1),
              ],
            ),
            const SizedBox(height: 20),

            // Estrelas de Avaliação
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return BotaoRecebeIcon(
                  Icons.star,
                  iconColor: index < _avaliacaoSelecionada
                      ? Colors.yellow
                      : Colors.grey,
                  iconSize: 40,
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
                hintText: 'Deixe um comentário... (obrigatório)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Botão para Adicionar Imagem
            ElevatedButton(
              onPressed: () {
                // Ação para adicionar imagem
                print("Funcionalidade de adicionar imagens ainda não implementada.");
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text('Clique aqui para adicionar imagens +'),
            ),
            const SizedBox(height: 30),

            // Botões de Cancelar e Salvar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BotaoCorTamanho(
                  label: 'Cancelar',
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                BotaoCorTamanho(
                  label: 'Salvar',
                  color: Colors.green,
                  onPressed: _salvarAvaliacao,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


