import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);
  // Função genérica para requisições GET
  Future<void> conexaoGet() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        print("Conexão bem-sucedida: ${response.body}");
      } else {
        print("Erro ao conectar: ${response.statusCode}");
      }
    } catch (e) {
      print("Exceção ao tentar conectar: $e");
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
