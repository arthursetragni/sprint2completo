import 'package:flutter/material.dart';
import 'package:login/widgets/block_button.dart';
import 'widgets/input_login.dart';
import 'services/api_service.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // Url base
  final apiService = ApiService("http://localhost:3000/");
  // Controladores dos inputs
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  void cadastrarUsuario() async {
    String nome = _nomeController.text;
    String email = _emailController.text;
    String senha = _senhaController.text;
    String confirmarSenha = _confirmarSenhaController.text;
    if (senha != confirmarSenha) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    print(
        "nome: $nome \nemail: $email\nsenha: $senha\nconfirmarSenha: $confirmarSenha");
    // Cria um mapa com os dados
    Map<String, dynamic> userData = {
      "name": nome,
      "email": email,
      "password": senha,
      "confirmPassword": confirmarSenha,
    };
    // Chamando o serviço da api
    final response = await apiService.conexaoPost("auth/register", userData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    } else if (response.statusCode == 422) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário já existe!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro no cadastro: ${response.statusCode}')),
      );
    }
  }

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
                isPassword: false,
                controller: _nomeController),
            const SizedBox(height: 20),
            // E-mail
            InputLogin(
              title: 'E-mail',
              label: 'Insira seu melhor E-mail',
              isPassword: false,
              controller: _emailController,
            ),

            const SizedBox(height: 20),
            // Senha
            InputLogin(
              title: 'Senha',
              label: 'Crie uma senha',
              isPassword: true,
              controller: _senhaController,
            ),
            const SizedBox(height: 20),
            // Botão de login
            InputLogin(
              title: 'Confirmar Senha',
              label: 'Confirme sua senha',
              isPassword: true,
              controller: _confirmarSenhaController,
            ),
            const SizedBox(height: 20),
            BlockButton(
              icon: Icons.check,
              label: "Cadastrar",
              onPressed: cadastrarUsuario,
            ),
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
                    Navigator.pushNamed(context, '/login');
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
