import 'package:flutter/material.dart';
import 'package:login/Login.dart';
import 'widgets/barra_nav.dart';
import 'widgets/editable_field.dart';
import 'widgets/editable_datafield.dart';
import 'widgets/ActionButton.dart';
import 'widgets/genero_botao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/User.dart';

class MeuPerfil extends StatefulWidget {
  final User usuario;
  const MeuPerfil({required this.usuario});

  @override
  State<MeuPerfil> createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final localizacaoController = TextEditingController();
  DateTime? dataNascimento;
  String genero = 'Masculino';
  String? idUsuario;
  String rotaBackEnd = 'https://backend-lddm.vercel.app';

  @override
  void initState() {
    super.initState();
    nomeController.text = widget.usuario.name;
    emailController.text = widget.usuario.email;
    idUsuario = widget.usuario.id;
    print(
        "${widget.usuario.name}, ${widget.usuario.email}, ${widget.usuario.id}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: const Color(0xFFFFFFFF),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Profile picture
              Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(radius: 40),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  // Name and profession
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nome do Usuário',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Profissão',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),

              // Campos editáveis
              EditableField(
                title: 'Nome',
                initialValue: nomeController.text,
                onChanged: (value) {
                  nomeController.text = value;
                  print("Nome alterado para $value");
                },
              ),
              EditableField(
                title: 'Email',
                initialValue: emailController.text,
                onChanged: (value) {
                  emailController.text = value;
                  print("Email alterado para $value");
                },
              ),
              EditableDateField(
                title: 'Data de Nascimento',
                initialDate: dataNascimento ?? DateTime(2000, 1, 1),
                onSave: (value) {
                  dataNascimento = value;
                  print("Data de nascimento alterada para $value");
                },
              ),
              EditableGenderField(
                title: 'Gênero',
                initialGender: genero,
                onGenderChanged: (value) {
                  genero = value;
                  print("Gênero alterado para $value");
                },
              ),
              EditableField(
                title: 'Telefone',
                initialValue: telefoneController.text,
                onChanged: (value) {
                  telefoneController.text = value;
                  print("Telefone alterado para $value");
                },
              ),
              EditableField(
                title: 'Localização',
                initialValue: localizacaoController.text,
                onChanged: (value) {
                  localizacaoController.text = value;
                  print("Localização alterada para $value");
                },
              ),

              // Botões de ação
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AccountActions(
                    onConfirm: () {
                      if (idUsuario != null) {
                        updateUser(idUsuario!).then((_) {
                          User usuarioAtualizado = User(
                            email: emailController.text,
                            name: nomeController.text,
                            id: idUsuario!,
                          );
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MeuPerfil(usuario: usuarioAtualizado),
                            ),
                          );
                        });
                      } else {
                        print("Erro: idUsuario é nulo");
                      }
                      // Lógica para salvar as alterações
                    },
                    onDelete: () {
                      if (idUsuario != null) {
                        deleteUser(idUsuario!).then((_) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BarraNav(),
    );
  }

  Future<void> deleteUser(String id) async {
    final url = Uri.parse('$rotaBackEnd/user/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print('Usuário deletado com sucesso :)');
      } else {
        print('Falha ao deletar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro na conexão: $error');
    }
  }

  // Função para enviar os dados ao backend
  Future<void> updateUser(String id) async {
    final url = Uri.parse('$rotaBackEnd/user/update/$id');
    final data = {
      'name': nomeController.text,
      'email': emailController.text,
      'dataNascimento': dataNascimento?.toIso8601String(),
      'genero': genero,
      'telefone': telefoneController.text,
      'localizacao': localizacaoController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Usuário atualizado com sucesso :)');
        // Limpa os campos após o envio
        // Quem colocou isso? Nem faz sentido
        // setState(() {
        //   nomeController.clear();
        //   emailController.clear();
        //   telefoneController.clear();
        //   localizacaoController.clear();
        //   dataNascimento = null;
        //   genero = 'Masculino';
      } else {
        print('Falha ao atualizar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro na conexão: $error');
    }
  }
}
