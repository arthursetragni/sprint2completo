import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'ResultadosPesquisa.dart';

class BarraPesquisa extends StatefulWidget {
  @override
  _BarraPesquisaState createState() => _BarraPesquisaState();
}

class _BarraPesquisaState extends State<BarraPesquisa> {
  final TextEditingController _controladorPesquisa = TextEditingController();
  final String _baseUrl = "http://localhost:3000/"; // URL base do backend
  //final String _baseUrl = "https://backend-lddm.vercel.app/";

  void _aoPressionarPesquisa() async {
    final textoPesquisa = _controladorPesquisa.text;

    if (textoPesquisa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um termo para buscar.")),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/servicos/busca?texto=$textoPesquisa"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> servicos = jsonResponse['servicos'];

        // Verifica e converte os serviços para o formato esperado
        final List<Map<String, dynamic>> servicosFormatados = servicos.map((item) {
          return {
            'imagem': item['imagem'] ?? '',
            'titulo': item['titulo'] ?? '',
            'descricao': item['descricao'] ?? '',
            'autor': item['autor'] ?? '',
          };
        }).toList();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultadosPesquisa(servicos: servicosFormatados),
          ),
        );
      } else if (response.statusCode == 404) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nenhum serviço encontrado.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erro ao buscar serviços: ${response.statusCode}.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao buscar serviços: $e")),
      );
    }
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
            onPressed: () {
              // Implementar lógica para pesquisa por áudio
            },
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
