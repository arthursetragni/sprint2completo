import 'package:flutter/material.dart';
import 'home.dart';
import 'widgets/input_login.dart';
import 'package:login/widgets/block_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:login/widgets/block_button_login.dart';
import 'widgets/barra_nav.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailControllerText = TextEditingController();
  final TextEditingController _senhaControllerText = TextEditingController();
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
                  onPressed: () => {Navigator.pushNamed(context, '/home')}),
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
}
