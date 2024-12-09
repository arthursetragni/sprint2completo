import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Categoria.dart';

//em teoria não precisa disso porque vai ser feito manualmente no BD
class CategoriaService {
  //definição da classe
  final String baseUrl;

  CategoriaService(this.baseUrl);

  //excluir uma categoria
  Future<http.Response> deletarCategoria(String endpoint, int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Categoria deletada com sucesso.");
      } else {
        print("Erro ao deletar categoria: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao deletar categoria: $e");
      rethrow;
    }
  }

    //atualizar uma avaliação
  Future<http.Response> atualizarCategoria(String endpoint, int id, Map<String, dynamic> data) async {
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

  //buscar uma avaliação específica - acho que no nosso caso não será muito usado, mas é bom para questões de teste
  Future<http.Response> buscarCategoriaPorId(String endpoint, int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Categoria encontrada: ${response.body}");
      } else {
        print("Erro ao buscar avaliação: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao buscar Categoria: $e");
      rethrow;
    }
  }

  //listar todas as categorias 
  Future<http.Response> listarCategorias(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("Categorias listadas com sucesso: ${response.body}");
      } else {
        print("Erro ao listar categorias: ${response.statusCode}");
      }
      return response;
    } catch (e) {
      print("Exceção ao listar avaliações: $e");
      rethrow;
    }
  }
}