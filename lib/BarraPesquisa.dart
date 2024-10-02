import 'package:flutter/material.dart';

class BarraPesquisa extends StatefulWidget {
  @override
  _BarraPesquisaState createState() => _BarraPesquisaState();
}

class _BarraPesquisaState extends State<BarraPesquisa> {
  final TextEditingController _controladorPesquisa = TextEditingController();

  void _aoPressionarPesquisa() {
    //lógica de pesquisa que eu ainda não sei
  }

  void _aoPressionarAudio() {
    // Lógica para captura de áudio
    //aqui implementa dps
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controladorPesquisa,
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: _aoPressionarAudio,
            tooltip: 'Pesquisa por voz',
          ),
                    IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: _aoPressionarPesquisa,
            tooltip: 'Pesquisar',
          )
        ],
      ),
    );
  }
}
