import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);
  // Função genérica para requisições GET
  Future<User?> autenticarUsuario(
      String endpoint, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Verifica se 'user' está presente e mapeia para um modelo User
        if (data['user'] != null) {
          return User.fromJson(data['user']);
        } else {
          print("Erro: Dados de usuário não encontrados.");
        }
      } else {
        print("Erro de autenticação: ${response.statusCode}");
      }
    } catch (e) {
      print("Exceção ao fazer login: $e");
    }
    return null;
  }

  // Função genérica POST
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
