import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CepEditable extends StatefulWidget {
  final String labelText;
  final String placeholder;
  final TextEditingController controller;

  const CepEditable({
    Key? key,
    required this.labelText,
    required this.placeholder,
    required this.controller,
  }) : super(key: key);

  @override
  _CepEditableState createState() => _CepEditableState();
}

class _CepEditableState extends State<CepEditable> {
  String endFinal = '';

  Future<void> _searchCep() async {
    final cep = widget.controller.text.replaceAll('-', '').trim();

    if (cep.length != 8 || int.tryParse(cep) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, insira um CEP válido!")),
      );
      return;
    }

    final url = Uri.parse('https://viacep.com.br/ws/$cep/json/');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey('erro')) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("CEP não encontrado!")),
          );
          return;
        }

        final logradouro = data['logradouro'] ?? '';
        final bairro = data['bairro'] ?? '';
        final localidade = data['localidade'] ?? '';
        final estado = data['uf'] ?? '';
        final complemento = data['complemento'] ?? '';

        TextEditingController complementoController = TextEditingController();

        await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text("Confirme os Dados do Endereço"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Alinhamento à esquerda
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Logradouro: $logradouro",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Bairro: $bairro",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Cidade: $localidade",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Estado: $estado",
                      textAlign: TextAlign.start,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: complementoController,
                      decoration: const InputDecoration(
                        labelText: "Complemento",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancelar"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          endFinal = [
                            logradouro,
                            complementoController.text,
                            bairro,
                            localidade,
                            estado
                          ].where((e) => e.isNotEmpty).join(", ");
                        });
                        Navigator.of(context).pop();
                      },
                      child: const Text("Salvar"),
                    ),
                  ],
                ),
              ],
            );
          },
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Endereço salvo: $endFinal")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erro ao buscar o CEP! Tente novamente.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erro de conexão. Verifique sua internet.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cepFormatter = MaskTextInputFormatter(
      mask: '#####-###',
      filter: {"#": RegExp(r'[0-9]')},
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 60),
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        inputFormatters: [cepFormatter],
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(bottom: 5),
          labelText: widget.labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: widget.placeholder,
          hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Colors.grey),
            onPressed: _searchCep,
          ),
        ),
      ),
    );
  }
}
