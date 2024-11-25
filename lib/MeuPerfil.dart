import 'package:flutter/material.dart';
import 'package:login/Login.dart';
import 'widgets/barra_nav.dart'; //barra de navegação
//import 'widgets/editable_field.dart'; //campo de texto
import 'widgets/editable_datafield.dart'; //campo de data
//import 'widgets/ActionButton.dart'; // old buttons
import 'widgets/genero_botao.dart'; //campo de gênero
import 'package:http/http.dart' as http; // Para requisições HTTP
import 'dart:convert'; // Para decodificar JSON
import 'package:shared_preferences/shared_preferences.dart'; // Para salvar dados localmente
import 'models/User.dart'; // Modelo de usuário
import 'package:awesome_dialog/awesome_dialog.dart'; // Para caixas de diálogo pop up
import 'widgets/text_editable.dart';

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
      print(usuario!.id);
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
        print("idUsuario Aqui em cima: $idUsuario");
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
            crossAxisAlignment:
                CrossAxisAlignment.start, //possível motivo de erro
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomeController.text, // Nome do usuário
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Profissão',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              //editable fields
              const SizedBox(height: 20),
              NewEditable(
                //Nome editable
                LabelText: "Nome",
                placeholder: nomeController.text,
                isPass: false,
              ),
              const SizedBox(height: 20),
              NewEditable(
                //email editable
                LabelText: "E-mail",
                placeholder: emailController.text,
                isPass: false,
              ),
              const SizedBox(height: 20),
              EditableDateField(
                //data de nascimento editable
                title: 'Data de Nascimento',
                initialDate: dataNascimento ?? DateTime(2000, 1, 1),
                onSave: (value) {
                  dataNascimento = value;
                  print("Data de nascimento alterada para $value");
                },
              ),
              EditableGenderField(
                //gênero editable
                title: 'Gênero',
                initialGender: genero,
                onGenderChanged: (value) {
                  genero = value;
                  print("Gênero alterado para $value");
                },
              ),
              const SizedBox(height: 20),
              NewEditable(
                LabelText: "Telefone",
                placeholder: telefoneController.text,
                isPass: false,
              ),
              const SizedBox(height: 20),
              NewEditable(
                LabelText: "Localização",
                placeholder: localizacaoController.text,
                isPass: false,
              ),

              //old editable
              //EditableField(
              //  title: 'Localização',
              //  controller: localizacaoController,
              //  onChanged: (value) {
              //    localizacaoController.text = value;
              //    print("Localização alterada para $value");
              //  },
              //),

              //new buttons - animated

              //!!!!!!!! Atention, test in android can be a problem !!!!!!!!

              SizedBox(height: 20),

              AnimatedButton(
                  text: "Update Account",
                  color: Colors.green,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Update Account",
                      desc: "U sure whants update your account?",
                      //Acts
                      btnCancelOnPress: () {
                        print("not green");
                      },
                      btnOkOnPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Account Updated")),
                        );
                        print("confirm green");
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
                    ).show();
                  }),

              SizedBox(height: 100),

              AnimatedButton(
                  text: "Exclude Account",
                  color: Colors.red,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Exclude Account",
                      desc: "U sure whants exclute your account?",
                      //Acts
                      btnCancelOnPress: () {
                        print("idUsuario: $idUsuario");
                        print("not red");
                      },
                      btnOkOnPress: () {
                        print("confirm red");
                        if (idUsuario != null) {
                          print("Usuário a ser deletado: $idUsuario");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account Deleted")),
                          );
                          deleteUser(idUsuario!).then((_) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Account Deleted")),
                          );
                        } else {
                          print("Erro: idUsuario é nulo");
                        }
                      },
                    ).show();
                  }),
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
