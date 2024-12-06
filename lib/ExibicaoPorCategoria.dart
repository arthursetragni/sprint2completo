import 'package:flutter/material.dart';
import 'widgets/barra_nav.dart';
import 'package:login/Login.dart';
import 'widgets/editable_field.dart';
import 'widgets/editable_datafield.dart';
import 'widgets/ActionButton.dart';
import 'widgets/genero_botao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TelaCategoria extends StatelessWidget {
  final String nomeCategoria; // Nome da categoria, vindo de forma dinâmica
  final List<Map<String, String>> servicos; // Lista dinâmica de serviços

  const TelaCategoria({
    Key? key,
    required this.nomeCategoria,
    required this.servicos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          nomeCategoria,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: servicos.length,
        itemBuilder: (context, index) {
          final servico = servicos[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            child: InkWell(
              onTap: () {
                // Ação ao clicar no card
                print('Serviço selecionado: ${servico['nome']}');
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (servico['imagem'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          servico['imagem']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          servico['nome'] ?? 'Nome não disponível',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          servico['descricao'] ?? 'Descrição não disponível',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BarraNav(), // Sua bottomNavigationBar existente
    );
  }
}

List<Map<String, String>> servicos = [
  {
    'nome': 'João Luiz Neves',
    'descricao': 'Encanador',
    'imagem': 'https://via.placeholder.com/150', // Substitua pelo URL real
  },
  {
    'nome': 'David dos Anjos',
    'descricao': 'Encanador',
    'imagem': 'https://via.placeholder.com/150', // Substitua pelo URL real
  },
];
