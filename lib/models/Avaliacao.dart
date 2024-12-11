class Avaliacao {
  String id;
  String ID_Avaliado;
  String ID_Avaliador;
  String? comentario;
  int? nota;
  DateTime? data; 

  Avaliacao({
    required this.id,
    required this.ID_Avaliado,
    required this.ID_Avaliador,
    this.comentario,
    this.nota,
    this.data,
  });

  // Modifique o fromJson para converter a string de data para DateTime
  factory Avaliacao.fromJson(Map<String, dynamic> json) {
    return Avaliacao(
      id: json['_id'],
      ID_Avaliado: json['ID_Avaliado'],
      ID_Avaliador: json['ID_Avaliador'],
      comentario: json['comentario'],
      nota: json['nota'],
      data: json['data'] != null ? DateTime.parse(json['data']) : null, // Conversão para DateTime
    );
  }
}

