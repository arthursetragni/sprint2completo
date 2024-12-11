import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // pontilhado da borda
import 'package:image_picker/image_picker.dart'; // para adicionar imagem
import 'dart:io';
import 'widgets/block_button.dart';
import 'widgets/input_login.dart';

class PostJob2 extends StatefulWidget {
  const PostJob2({Key? key}) : super(key: key);

  @override
  State<PostJob2> createState() => PostJob2State();
}

class PostJob2State extends State<PostJob2> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = []; // Lista de fotos selecionadas
  String? _selectedCategory; // Variável para armazenar a categoria selecionada

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
                controller: TextEditingController(),
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
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Deixe aqui sua  descrição',
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
                controller: TextEditingController(),
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
                onPressed: () {
                  // Ação do botão "Next", se necessário
                  if (_selectedCategory == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Selecione uma categoria!')),
                    );
                  } else {
                    // Lógica para continuar com a criação do portfólio
                    print('Categoria selecionada: $_selectedCategory');
                  }
                },
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
      "https://a818e189411ced5f77a53d57ecc59f11.serveo.net";

  // Método para gerar a URL de rotas específicas
  static String endpoint(String path) {
    return "$baseUrl$path";
  }
}
