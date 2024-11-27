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
//import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
//import 'widgets/input_login.dart'; //campo de texto para teste TESTE

class MeuPerfil extends StatefulWidget {
  @override
  State<MeuPerfil> createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final telefoneController = TextEditingController();
  final localizacaoController = TextEditingController();
  final dataNascimentoController = TextEditingController();
  //DateTime? dataNascimento; old data
  String? genero;
  String? idUsuario;
  String rotaBackEnd = 'https://backend-lddm.vercel.app';

  //adicionar controller nos inputs de texto !!!!!!!!!!!!!!!!!!!!!!!!!

  //DateTime? editDataNascimento;
  final editDataNascimentoController = TextEditingController();
  final editNomeController = TextEditingController();
  final editGenero = TextEditingController();
  final editEmailController = TextEditingController();
  final editTelefoneController = TextEditingController();
  final editLocalizacaoController = TextEditingController();

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
        telefoneController.text = usuario!.telephone ??
            '(XX) XXXX-XXXX'; //prefs.getString('telefone') ?? '';
        localizacaoController.text = usuario!.adress ??
            'XXXXX-XXX'; //prefs.getString('localizacao') ?? '';
        //OLD DATA //dataNascimento = DateTime.tryParse(usuario!.date_of_birth as String? ?? '');
        dataNascimentoController.text =
            usuario!.date_of_birth as String? ?? 'DD/MM/AAAA';
        genero = usuario?.gender; //prefs.getString('genero') ?? '';
        idUsuario = usuario!.id;
      });
    }
  }

  Future<void> _saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('telephone', telefoneController.text);
    await prefs.setString('adress', localizacaoController.text);
    await prefs.setString(
        'date_of_birth',
        dataNascimentoController
            .text); //dataNascimento?.toIso8601String() ?? '');
    await prefs.setString('genero', genero ?? '');
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

              //old editable TEST
              //InputLogin(
              //    title: "nome",
              //    label: nomeController.text,
              //    isPassword: false,
              //    controller: editNomeController,
              //    isEmail: false),

              NewEditable(
                //Nome editable
                LabelText: "Nome",
                controller: editNomeController,
                placeholder: nomeController.text,
                isPass: false,
                isDate: false,
                isCell: false,
                //returnController: editNomeController,
              ),
              const SizedBox(height: 20),
              NewEditable(
                //email editable
                LabelText: "E-mail",
                controller: editEmailController,
                placeholder: emailController.text,
                isPass: false,
                isDate: false,
                isCell: false,
              ),
              const SizedBox(height: 20),
              NewEditable(
                LabelText: "Data de Nascimento",
                controller: editDataNascimentoController,
                placeholder: dataNascimentoController.text,
                isPass: false,
                isDate: true,
                isCell: false,
              ),

              //old editable Date
              //EditableDateField(
              //  //data de nascimento editable
              //  title: 'Data de Nascimento',
              //  initialDate: dataNascimento ?? DateTime(2000, 1, 1),
              //  onSave: (value) {
              //    dataNascimento = value;
              //    print("Data de nascimento alterada para $value");
              //  },
              //),

              EditableGenderField(
                //gênero editable
                title: 'Gênero',
                initialGender: genero ?? '',
                onGenderChanged: (value) {
                  genero = value;
                  print("Gênero alterado para $value");
                },
              ),
              const SizedBox(height: 20),
              NewEditable(
                LabelText: "Telefone",
                controller: editTelefoneController,
                placeholder: telefoneController.text,
                isPass: false,
                isDate: false,
                isCell: true,
              ),
              const SizedBox(height: 20),
              NewEditable(
                LabelText: "Localização",
                controller: editLocalizacaoController,
                placeholder: localizacaoController.text,
                isPass: false,
                isDate: false,
                isCell: false,
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
              const SizedBox(height: 20),

              AnimatedButton(
                  text: "Confirmar",
                  color: Colors.green,
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.success,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      title: "Atualizar Conta",
                      desc: "Tem certeza que deseja atualizar sua conta?",
                      //Acts
                      btnCancelOnPress: () {
                        print("not green");
                      },
                      btnOkOnPress: () {
                        makingchange();
                        print("confirm green");
                        if (idUsuario != null) {
                          updateUser(idUsuario!).then((_) {
                            //Navigator.of(context).pushReplacement(
                            //  MaterialPageRoute(
                            //    builder: (context) =>
                            //        MeuPerfil(), // Removido o argumento `usuario`
                            //  ),
                            //);
                          });
                        } else {
                          print("Erro: idUsuario é nulo");
                        }
                      },
                    ).show();
                  }),

              SizedBox(height: 30),
              Center(
                  child: Text(
                "Versão 1.3",
                style: TextStyle(
                  fontSize: 18, // Ajuste o tamanho da fonte conforme necessário
                  color: Colors.grey.shade600, // Cinza claro
                  fontWeight: FontWeight.w400, // Peso leve para o texto
                ),
              )),

              SizedBox(height: 30),

              AnimatedButton(
                  text: "Excluir Conta",
                  buttonTextStyle: const TextStyle(
                    //fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  color: const Color.fromARGB(255, 236, 236, 236),
                  pressEvent: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.topSlide,
                      showCloseIcon: true,
                      titleTextStyle: const TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                      title: "Excluir Conta",
                      desc: "Tem certeza que deseja excluir sua conta?",
                      //Acts
                      btnCancelOnPress: () {
                        print("idUsuario: $idUsuario");
                        print("not red");
                      },
                      btnOkOnPress: () {
                        print("confirm red");
                        if (idUsuario != null) {
                          print("Usuário a ser deletado: $idUsuario");
                          //ScaffoldMessenger.of(context).showSnackBar(
                          //  SnackBar(content: Text("Account Deleted")),
                          //);
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

  //função para evitar que os campos fiquem vazios
  void makingchange() {
    if (editNomeController.text == '') {
      editNomeController.text = nomeController.text;
    }
    if (editEmailController.text == '') {
      editEmailController.text = emailController.text;
    }
    if (editTelefoneController.text == '') {
      editTelefoneController.text = telefoneController.text;
    }
    if (editLocalizacaoController.text == '') {
      editLocalizacaoController.text = localizacaoController.text;
    }
    if (editDataNascimentoController == '') {
      editDataNascimentoController.text = dataNascimentoController.text;
    }
  }

  Future<void> updateUser(String id) async {
    final url = Uri.parse('$rotaBackEnd/user/update/$id');
    final data = {
      'name': editNomeController.text,
      'email': editEmailController.text, //editEmailController.text,
      'date_of_birth': editDataNascimentoController
          .text, //dataNascimento?.toIso8601String(),
      'genero': genero,
      'telephone': editTelefoneController.text,
      'adress': editLocalizacaoController.text,
    };
    print('Dados enviados para o backend: $data');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Usuário atualizado com sucesso :)');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account Updated")),
        );

/* TESTE UPDATE USER
        //atualizar o update
        nomeController.text = editNomeController.text;
        emailController.text = editEmailController.text;
        telefoneController.text = editTelefoneController.text;
        localizacaoController.text = editLocalizacaoController.text;
        //dataNascimento = editDataNascimento;
        dataNascimentoController.text = editDataNascimentoController.text;
        //genero = editGenero.text;

        User usuarioAtualizado = User(
          email: editEmailController.text,
          name: editNomeController.text,
          date_of_birth: DateTime.tryParse(
              editDataNascimentoController.text), //dataNascimento,
          gender: genero,
          telephone: editTelefoneController.text,
          adress: editLocalizacaoController.text,
          id: idUsuario!,
        );
        await _saveUserData(usuarioAtualizado);
        setState(() {
          idUsuario = usuarioAtualizado.id;
        });*/
      } else {
        print('Falha ao atualizar usuário: ${response.statusCode}');
        if (response.statusCode == 400) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usu´rio não encontrado")),
          );
        } else if (response.statusCode == 500) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Erro ao atualizar usuário, tente novamente mais tarde")),
          );
        }
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
