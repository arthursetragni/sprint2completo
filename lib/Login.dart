import 'package:flutter/material.dart';
import 'package:login/MeuPerfil.dart';
import 'package:login/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'widgets/input_login.dart';
import 'package:login/widgets/block_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/widgets/block_button_login.dart';
import 'widgets/barra_nav.dart';
import 'services/api_service.dart';
import 'models/User.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailControllerText = TextEditingController();
  final TextEditingController _senhaControllerText = TextEditingController();
  // Url base
  final apiService = ApiService("https://backend-lddm.vercel.app/");
  User? usuario; // Variável para armazenar o usuário recuperado

  void realizarLogin() async {
    final email = _emailControllerText.text;
    final senha = _senhaControllerText.text;
    final response = await apiService.logarUsuario('auth/login', email, senha);
    usuario = response['user'];
    final int statusCode = response['statusCode'];
    setState(() {
      this.usuario = usuario; // Armazena o usuário autenticado
    });

    if (usuario != null) {
      print("Login bem-sucedido: ${usuario!.name}, Email: ${usuario!.email}");
      // print(usuario!.id);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MeuPerfil(
                    usuario: User(
                  name: usuario!.name,
                  email: usuario!.email,
                  id: usuario!.id,
                ))),
      );
    } else {
      String errorMessage;
      if (statusCode == 1) {
        errorMessage = 'Usuário não encontrado. Verifique as credenciais.';
      } else if (statusCode == 2) {
        errorMessage = 'Senha incorreta. Tente novamente.';
      } else {
        errorMessage = 'Erro ao fazer login. Tente novamente mais tarde.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          color: const Color(0xFFFFFFFF),
          padding:
              const EdgeInsets.all(16.0), // Adiciona um espaçamento interno
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Alinha os widgets à esquerda
            children: [
              // Parte da seta para voltar
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context); // Volta para a tela anterior
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20), // Adiciona espaço entre os elementos
              const Text(
                'Bem vindo de volta!',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 20,
              ),
              // Parte do input com texto 1
              InputLogin(
                title: "E-mail",
                label: 'Seu melhor E-mail',
                isPassword: false,
                controller: _emailControllerText,
              ),
              const SizedBox(height: 20),

              // Parte do input com texto 2 (senha)
              InputLogin(
                title: 'Senha',
                label: 'Digite sua melhor senha',
                isPassword: true,
                controller: _senhaControllerText,
              ),

              const SizedBox(height: 10),
              const Text(
                'Esqueceu sua senha?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),

              // Botão de login
              BlockButton(
                icon: Icons.check,
                label: "Logar",
                onPressed: realizarLogin,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Não possui uma conta ainda? ',
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/cadastro');
                    },
                    child: const Text(
                      "Inscrever-se",
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Ou centralizado
              const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Ou',
                  style: TextStyle(fontSize: 16),
                ),
              ]),
              const SizedBox(height: 20),
              BlockButtonLogin(
                icon: SvgPicture.asset(
                  'assets/icons/chrome.svg',
                  height: 24,
                  width: 24,
                ),
                label: "Entrar com o Google",
                onPressed: () => {},
              ),
              const SizedBox(height: 20),
              BlockButtonLogin(
                icon: SvgPicture.asset(
                  'assets/icons/apple.svg',
                  height: 24,
                  width: 24,
                ),
                label: "Entrar com a Apple",
                onPressed: () => {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _salvaDados() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString("nome", _controller.text);
  // }

  // _recuperaDados() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _textoSalvo = prefs.getString("nome") ?? "sem valor";
  //   });
  // }

  // _removerDados() async{
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove("nome");
  // }
}
