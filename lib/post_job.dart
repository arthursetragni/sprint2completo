import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // pontilhado da borda
import 'package:image_picker/image_picker.dart'; // para adicionar imagem
import 'dart:io';
import 'widgets/block_button.dart';
import 'widgets/input_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // para acessar SharedPreferences
import 'models/User.dart'; // Importe a classe User do seu arquivo de modelos

class PostJob extends StatefulWidget {
  const PostJob({Key? key}) : super(key: key);

  @override
  State<PostJob> createState() => PostJobState();
}

class PostJobState extends State<PostJob> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = []; // Lista de fotos selecionadas
  String? _selectedCategory; // Variável para armazenar a categoria selecionada
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  // Lista de categorias predefinidas
  final List<String> _categories = [
    "Pintor",
    "Empregada",
    "Eletricista",
    "Encanador",
  ];

  // Função para selecionar uma imagem da galeria
  Future<void> _pickImage() async {
    if (_selectedImages.length >= 5) {
      // Limite de 5 fotos
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Você só pode adicionar até 5 fotos!')),
      );
      return;
    }

    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImages.add(File(pickedImage.path));
      });
    }
  }

  // Função para remover uma imagem da lista
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitForm() async {
    if (_selectedCategory == null ||
        _titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    try {
      // Recuperar o id do usuário salvo no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final usuarioJson = prefs.getString("usuario");

      if (usuarioJson != null) {
        final user = User.fromJson(jsonDecode(usuarioJson));

        final response = await http.post(
          Uri.parse("${ApiServices.baseUrl}/servico"),
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "titulo": _titleController.text,
            "descricao": _descriptionController.text,
            "preco_acordado": double.parse(_priceController.text),
            "categoria": _getCategoryNumber(_selectedCategory),
            "id_criador": user.id,
            "cep": "123456789",
            "tipo": "Residencial",
            "id_executor":
                "000000000000000000000000", // Fica vazio inicialmente
            "data_criacao": DateTime.now().toIso8601String(),
          }),
        );

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço criado com sucesso!')),
          );
          Navigator.pop(context);
        } else {
          throw Exception('Erro ao criar serviço');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString()}')),
      );
    }
  }

  // Função para mapear a categoria para o número
  int _getCategoryNumber(String? category) {
    switch (category) {
      case "Pintor":
        return 1;
      case "Empregada":
        return 2;
      case "Eletricista":
        return 3;
      case "Encanador":
        return 4;
      default:
        return 0; // Caso não tenha categoria selecionada
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.all(16), // Espaço ao redor da borda
          decoration: BoxDecoration(
            color: Colors.white, // Cor de fundo da tela
            borderRadius: BorderRadius.circular(0), // Borda arredondada
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button e título
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const Text(
                      'Do que precisa?',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Input de título do trabalho
              InputLogin(
                title: "Trabalho",
                label: 'Digite aqui o título do trabalho',
                isPassword: false,
                isEmail: false,
                controller: _titleController,
              ),
              const SizedBox(height: 20),

              // Campo de descrição
              Text(
                'Descrição',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Deixe aqui sua descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),

              // Input de preço
              InputLogin(
                title: "Preço",
                label: 'Digite aqui o valor do trabalho',
                isPassword: false,
                isEmail: false,
                controller: _priceController,
              ),
              const SizedBox(height: 20),

              // Dropdown de categoria
              Text(
                'Categoria',
                style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 9),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Selecione uma categoria'),
                items: _categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Botão para avançar
              BlockButton(
                icon: Icons.check,
                label: "Next",
                onPressed: _submitForm, // Envia os dados para a API
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ApiServices {
  // URL base da API, definida como constante
  static const String baseUrl =
      "https://backend-lddm.vercel.app";

  // Método para gerar a URL de rotas específicas
  static String endpoint(String path) {
    return "$baseUrl$path";
  }
}
