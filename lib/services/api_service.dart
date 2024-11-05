import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);
  // Função para recuperar dados de usuário
  Future<Map<String, dynamic>> logarUsuario(
      String endpoint, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Verifica se 'user' está presente e mapeia para um modelo User
        if (data['user'] != null) {
          return {'user': User.fromJson(data['user']), 'statusCode': 200};
        } else {
          print("Erro: Dados de usuário não encontrados.");
          return {'user': null, 'statusCode': 500};
        }
      } else {
        final Map<String, dynamic> respostaErro = jsonDecode(response.body);
        print("Erro de autenticação: ${response.body}");

        return {'user': null, 'statusCode': respostaErro['code']};
      }
    } catch (e) {
      print("Exceção ao fazer login: $e");
      return {'user': null, 'statusCode': 500};
    }
  }

  // Função para fazer o register do user
  Future<http.Response> conexaoPost(
      String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print("POST bem sucedido: ${response.body}");
      } else {
        print("Erro no POST: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao fazer post: $e");
      rethrow;
    }
  }
}
