import 'dart:convert';

import 'package:http/http.dart' as http;


class ApiCepService {
  final String baseUrl;
  ApiCepService(this.baseUrl);

  // Função para recuperar informações de cep
  Future<Map<String, dynamic>> recuperarCep(String cep) async{
    try{
      final response = await http.get(
        Uri.parse('$baseUrl$cep')
      );
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        return {'Cep' : data};
      }else{
        final Map<String, dynamic> respostaErro = jsonDecode(response.body);
        print("Erro de autenticação: ${response.body}");
        return {'user': null, 'statusCode': respostaErro['code']};
      }
    }catch(e){
      print("Exceção ao recuperar o cep: $e");
      return{'cep' : null};
    }
  }
}