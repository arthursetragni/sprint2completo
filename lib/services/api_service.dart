import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);
  // Função genérica para requisições GET
  // Função GET para buscar o usuário e deserializar em um modelo User
  Future<User?> autenticarUsuario(
      String endpoint, String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return User.fromJson(jsonData); // Converte JSON para User
      } else {
        print("Erro ao autenticar: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Exceção ao tentar autenticar: $e");
      return null;
    }
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
