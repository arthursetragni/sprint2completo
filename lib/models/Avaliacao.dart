class Avaliacao {
  String id;
  String ID_Avaliado;
  String ID_Avaliador;
  String ID_Servico;
  String? comentario;
  int? nota;
  DateTime? data;

  Avaliacao({required this.id, required this.ID_Avaliado, required this.ID_Avaliador, required this.ID_Servico, this.comentario, this.nota, this.data});

  //método para usar o modelo Avaliacao
  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['_id'] ?? 'Id desconhecido',
      ID_Avaliado: json['ID_Avaliado'] ?? 'Id de quem está sendo avaliado desconhecido',
      ID_Avaliador: json['ID_Avaliador'] ?? 'Id de quem avalia desconhecido',
      ID_Servico: json['ID_Servico'] ?? 'Id do serviço desconhecido',
      comentario: json['coementario'] ?? 'Sem comentario',
      nota: json['nota'] ?? 'Sem nota',
      data: json['data'] ?? 'Sem data',
    );
  }

  // Método para converter nosso modelo para Json
  Map<String, dynamic> toJson() => {
    '_id': id,
    'ID_Avaliado': ID_Avaliado,
    'ID_Avaliador': ID_Avaliador,
    'ID_Servico': ID_Servico,
    'comentario': comentario,
    'nota': nota,
    'data': data,
  };
}

