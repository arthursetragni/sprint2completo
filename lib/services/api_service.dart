import 'dart:convert';
import 'dart:io'; // Para usar HttpClient e permitir certificados autoassinados
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  // Função para criar o cliente HTTP com suporte a certificados autoassinados
  http.Client _getHttpClient() {
    // Ignorar erros de certificado (somente para desenvolvimento)
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Ignora erro de certificado
    return IOClient(httpClient); // Retorna o IOClient configurado
  }

  // Função para fazer login
  Future<Map<String, dynamic>> logarUsuario(
      String endpoint, String email, String senha) async {
    try {
      final client = _getHttpClient(); // Obtém o cliente HTTP configurado

      final response = await client.post(
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
        print("Erro de autenticação: ${respostaErro['message']}");
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
      final client = _getHttpClient(); // Obtém o cliente HTTP configurado

      final response = await client.post(
        Uri.parse('$baseUrl$endpoint'),
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
