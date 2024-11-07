import 'package:flutter/material.dart';
import 'package:login/Login.dart';
import 'widgets/barra_nav.dart';
import 'widgets/editable_field.dart';
import 'widgets/editable_datafield.dart';
import 'widgets/ActionButton.dart';
import 'widgets/genero_botao.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/User.dart';

class MeuPerfil extends StatefulWidget {
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
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    print('Buscando dados salvos no meuPerfil');
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString("usuario");
    User? usuario;

    if (usuarioJson != null) {
      setState(() {
        usuario = User.fromJson(jsonDecode(usuarioJson));
      });
    }

    if (usuario != null) {
      print("Valores recuperados");

      // Preenchendo os controladores com os valores do usuário
      setState(() {
        nomeController.text = usuario!.name; // Assume que o nome não é nulo
        emailController.text = usuario!.email; // Assume que o email não é nulo
        telefoneController.text = prefs.getString('telefone') ?? '';
        localizacaoController.text = prefs.getString('localizacao') ?? '';
        dataNascimento =
            DateTime.tryParse(prefs.getString('dataNascimento') ?? '');
        genero = prefs.getString('genero') ?? '';
        idUsuario = prefs.getString('id');
      });
    }
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('telefone', telefoneController.text);
    await prefs.setString('localizacao', localizacaoController.text);
    await prefs.setString(
        'dataNascimento', dataNascimento?.toIso8601String() ?? '');
    await prefs.setString('genero', genero);
    await prefs.setString('id', user.id);
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
                controller: nomeController,
                onChanged: (value) {
                  nomeController.text = value;
                  print("Nome alterado para $value");
                },
              ),
              EditableField(
                title: 'Email',
                controller: emailController,
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
                controller: telefoneController,
                onChanged: (value) {
                  telefoneController.text = value;
                  print("Telefone alterado para $value");
                },
              ),
              EditableField(
                title: 'Localização',
                controller: localizacaoController,
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
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) =>
                                  MeuPerfil(), // Removido o argumento `usuario`
                            ),
                          );
                        });
                      } else {
                        print("Erro: idUsuario é nulo");
                      }
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
        User usuarioAtualizado = User(
          email: emailController.text,
          name: nomeController.text,
          id: idUsuario!,
        );
        await _saveUserData(usuarioAtualizado);
        setState(() {
          idUsuario = usuarioAtualizado.id;
        });
      } else {
        print('Falha ao atualizar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro na conexão: $error');
    }
  }

  Future<void> deleteUser(String id) async {
    final url = Uri.parse('$rotaBackEnd/user/$id');
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print('Usuário deletado com sucesso :)');
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear(); // Limpa os dados do usuário
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Login()),
        );
      } else {
        print('Falha ao deletar usuário: ${response.statusCode}');
      }
    } catch (error) {
      print('Erro na conexão: $error');
    }
  }
}
