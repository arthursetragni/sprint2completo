import 'package:flutter/material.dart';
import 'widgets/botao_recebe_icon.dart'; 
import 'widgets/botao_cor_tamanho.dart';

class TelaAvaliacao extends StatefulWidget {
  @override
  _TelaAvaliacaoState createState() => _TelaAvaliacaoState();
}

class _TelaAvaliacaoState extends State<TelaAvaliacao> {
  int _avaliacaoSelecionada = 0;

  void _selecionarAvaliacao(int indice) {
    setState(() {
      _avaliacaoSelecionada = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // título com linha
            Column(
              children: [
                Text(
                  'Avalie o serviço',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
            const TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Deixe um comentário...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
 
            // Botão para Adicionar Imagem
            ElevatedButton(
              onPressed: () {
                // Ação para adicionar imagem
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.black),
                ),
              ),
              child: Text('Clique aqui para adicionar imagens +'),
            ),
            SizedBox(height: 30),

            // Botões de Cancelar e Salvar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                BotaoCorTamanho(
                  label: 'Cancelar',
                  color: Colors.red,
                  onPressed: () {
                    // Ação para cancelar
                  },
                ),
                BotaoCorTamanho(
                  label: 'Salvar',
                  color: Colors.green,
                  onPressed: () {
                    // Ação para salvar
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

