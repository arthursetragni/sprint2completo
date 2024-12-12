import 'package:flutter/material.dart';
import 'package:login/Login.dart';
import 'widgets/barra_nav.dart'; //barra de navegação
import 'widgets/genero_botao.dart'; //campo de gênero
import 'package:http/http.dart' as http; // Para requisições HTTP
import 'dart:convert'; // Para decodificar JSON
import 'package:shared_preferences/shared_preferences.dart'; // Para salvar dados localmente
import 'models/User.dart'; // Modelo de usuário
import 'package:awesome_dialog/awesome_dialog.dart'; // Para caixas de diálogo pop up
import 'widgets/text_editable.dart';
import 'package:intl/intl.dart';
import 'widgets/cep.dart';

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
  //DateTime? dataNascimento;
  String? genero;
  String? idUsuario;
  String rotaBackEnd = 'https://backend-lddm.vercel.app';

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
            '(XX) XXXX-XXXX'; // prefs.getString('telefone') ?? '';
        localizacaoController.text = usuario!.adress ??
            'XXXXX-XXX'; // prefs.getString('localizacao') ?? '';

// Alteração na manipulação da data de nascimento
        try {
          // Verifique se a data está em formato ISO 8601 e converta para DateTime
          if (usuario!.date_of_birth != null) {
            DateTime dateTime = DateTime.parse(usuario!.date_of_birth!);

            // Formatar a data no formato 'dd/MM/yyyy'
            String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);

            print(formattedDate); // Saída: 01/02/2001
          }
        } catch (e) {
          print("Erro ao formatar a data: $e");
        }

        DateFormat formatter = DateFormat('dd/MM/yyyy');
        if (usuario!.date_of_birth != null) {
          // Atribuindo a data formatada ao controller
          dataNascimentoController.text =
              formatter.format(DateTime.parse(usuario!.date_of_birth!));
        }

        genero = usuario?.gender; // prefs.getString('genero') ?? '';
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
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/icons/user.png'),
                      ),
                      Positioned(
                        bottom: -12,
                        right: -17,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            size: 20,
                            color: const Color.fromARGB(255, 41, 41, 41),
                          ),
                          onPressed: () {
                            print("tu clicou na foto, parabéns");
                          },
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
              CepEditable(
                labelText: "Localização",
                controller: editLocalizacaoController,
                placeholder: localizacaoController.text,
              ),


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
    DateFormat format = DateFormat('dd/MM/yyyy');
    DateTime parsedDate;

    try {
      parsedDate = format.parse(editDataNascimentoController.text);
    } catch (e) {
      print("Erro ao converter data: $e");
      parsedDate = DateTime.now(); // Define uma data padrão em caso de erro
    }

    // Convertendo a data para string antes de enviá-la
    final data = {
      'name': editNomeController.text,
      'email': editEmailController.text,
      'date_of_birth':
          parsedDate.toIso8601String(), // Convertendo para ISO 8601
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
          SnackBar(content: Text("Conta atualizada com sucesso!")),
        );

        // Atualizando localmente
        print("chegou pre usuario atualizado");
        User usuarioAtualizado = User(
          email: editEmailController.text,
          name: editNomeController.text,
          date_of_birth: parsedDate,
          gender: genero,
          telephone: editTelefoneController.text,
          adress: editLocalizacaoController.text,
          id: idUsuario!,
        );
        Future<void> saveUser(User usuarioAtualizado) async {
          print("salvando usuario...");
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              "usuario", jsonEncode(usuarioAtualizado.toJson()));
          print("Sucesso!");
        }

        Future<void> printUsuarioSalvo() async {
          print("printando usuario pos save user novo");
          final prefs = await SharedPreferences.getInstance();
          final usuarioJson = prefs.getString("usuario");

          if (usuarioJson != null) {
            final user = User.fromJson(jsonDecode(usuarioJson));
            print(
                "Usuário salvo: Nome: ${user.name}, Email: ${user.email}, Id : ${user.id}\n Genêro: ${user.gender}, Telefone: ${user.telephone}, Endereço: ${user.adress}\n Data de Nascimento: ${user.date_of_birth}");
          } else {
            print("Nenhum usuário salvo encontrado.");
          }
        }

        await _saveUserData(usuarioAtualizado);
        setState(() {
          idUsuario = usuarioAtualizado.id;
        });
      } else {
        print('Falha ao atualizar usuário: ${response.statusCode}');
        if (response.statusCode == 404) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuário não encontrado")),
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
