import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart'; // pontilhado da borda
import 'package:image_picker/image_picker.dart'; // para adicionar imagem
import 'dart:io';
import 'widgets/block_button.dart';
import 'widgets/input_login.dart';

class PostJob extends StatefulWidget {
  const PostJob({Key? key}) : super(key: key);

  @override
  State<PostJob> createState() => PostJobState();
}

class PostJobState extends State<PostJob> {
  final ImagePicker _picker = ImagePicker();
  List<File> _selectedImages = []; // Lista de fotos selecionadas

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
            //border: Border.all(
            //color: Colors.white,  // Cor da borda
            //width: 2,  // Largura da borda
            //),
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
                      'Crie Seu Portifolio',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Container com borda pontilhada para adicionar foto
              Center(
                child: DottedBorder(
                  color: Colors.grey,
                  strokeWidth: 3,
                  dashPattern: [22, 10],
                  borderType: BorderType.RRect,
                  radius: const Radius.circular(12),
                  child: InkWell(
                    onTap: _pickImage,
                    child: Container(
                      width: 280,
                      height: 200,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white70, // Cor de fundo
                        borderRadius: BorderRadius.circular(
                            12), // Arredonda os cantos do fundo
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                            color: Colors.deepOrange,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Adicionar Foto',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepOrangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Exibição das fotos adicionadas
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Fotos Adicionadas:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              // Carrossel horizontal para exibir as imagens
              SizedBox(
                height: 120, // Altura da linha de fotos
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: FileImage(_selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Botão de remover (X)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Parte do input com texto 1
              InputLogin(
                title: "Trabalho",
                label: 'Digite aqui o titulo do trabalho',
                isPassword: false,
                isEmail: false,
                controller: TextEditingController(),
              ),
              const SizedBox(height: 20),
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
              InputLogin(
                title: "Preço",
                label: 'Digite aqui o valor do trabalho',
                isPassword: false,
                isEmail: false,
                controller: TextEditingController(),
              ),
              const SizedBox(height: 30),
              BlockButton(
                icon: Icons.check,
                label: "Next",
                onPressed: null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
