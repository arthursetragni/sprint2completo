import 'package:flutter/material.dart';
import 'package:login/widgets/block_button.dart';
import 'widgets/input_login.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFFFFFFFF),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => {
                    Navigator.pop(context),
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Crie sua conta',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            // Row dos inputs de cadastro
            // Nome
            InputLogin(
                title: 'Nome',
                label: 'Insira seu nome completo',
                isPassword: false),
            const SizedBox(height: 20),
            // E-mail
            InputLogin(
                title: 'E-mail',
                label: 'Insira seu melhor E-mail',
                isPassword: false),
            const SizedBox(height: 20),
            // Senha
            InputLogin(
                title: 'Senha', label: 'Crie uma senha', isPassword: true),
            const SizedBox(height: 20),
            // Botão de login
            BlockButton(
                icon: Icons.check,
                label: "Cadastrar",
                onPressed: () => {Navigator.pushNamed(context, '/home')}),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Já possui uma conta? ',
                  style: TextStyle(fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/cadastro');
                  },
                  child: const Text(
                    "Logar",
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
