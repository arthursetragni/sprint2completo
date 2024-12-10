import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Avaliacao.dart';

class AvaliacaoService {
  final String baseUrl;

  AvaliacaoService(this.baseUrl);

  Future<http.Response> criaAvaliacao(String endpoint, Map<String, dynamic> data) async {
    try {
      print(data);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("Avaliação enviada com sucesso: ${response.body}");
      } else {
        print("Erro ao enviar avaliação: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao enviar avaliação: $e");
      rethrow;
    }
  }

  Future<http.Response> deletarAvaliacao(String endpoint, String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliação deletada com sucesso.");
      } else {
        print("Erro ao deletar avaliação: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao deletar avaliação: $e");
      rethrow;
    }
  }

  Future<http.Response> atualizarAvaliacao(String endpoint, String id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Avaliação atualizada com sucesso: ${response.body}");
      } else {
        print("Erro ao atualizar avaliação: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao atualizar avaliação: $e");
      rethrow;
    }
  }

  Future<http.Response> buscarAvaliacaoPorId(String endpoint, String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliação encontrada: ${response.body}");
      } else {
        print("Erro ao buscar avaliação: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao buscar avaliação: $e");
      rethrow;
    }
  }

  Future<http.Response> listarAvaliacoes(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliações listadas com sucesso: ${response.body}");
      } else {
        print("Erro ao listar avaliações: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao listar avaliações: $e");
      rethrow;
    }
  }

  Future<http.Response> buscarAvaliacoesPorUsuario(String endpoint, int idAvaliador) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?ID_Avaliador=$idAvaliador'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliações do usuário encontradas: ${response.body}");
      } else {
        print("Erro ao buscar avaliações do usuário: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao buscar avaliações do usuário: $e");
      rethrow;
    }
  }

  Future<http.Response> buscarAvaliacoesPorTrabalhador(String endpoint, String idAvaliado) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?ID_Avaliado=$idAvaliado'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliações do trabalhador encontradas: ${response.body}");
      } else {
        print("Erro ao buscar avaliações do trabalhador: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao buscar avaliações relacionadas a esse trabalhador: $e");
      rethrow;
    }
  }

  Future<http.Response> buscarAvaliacoesPorServico(String endpoint, String idServico) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint?ID_Servico=$idServico'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Avaliações do serviço: ${response.body}");
      } else {
        print("Erro ao buscar avaliações do serviço: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao buscar avaliações do serviço: $e");
      rethrow;
    }
  }

  Future<http.Response> buscarAvaliacao(String endpoint, Map<String, String> parametros) async {
    final response = await http.get(
        Uri.parse('$baseUrl$endpoint$parametros'),
        headers: {'Content-Type': 'application/json'},
      );
    if (response.statusCode == 200) {
      print("Avaliação encontrada: ${response.body}");
    } else {
      print("Erro ao buscar avaliação: ${response.statusCode}");
    }
    return response;
}
}
