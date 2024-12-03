class Categoria {
  String id;
  String nome;

  Categoria({required this.id, required this.nome});

  //método para usar o modelo Avaliacao
  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['_id'] ?? 'Id desconhecido',
      nome: json['nome'] ?? 'Nome da categoria desconhecido',
    );
  }

  // Método para converter nosso modelo para Json
  Map<String, dynamic> toJson() => {
    '_id': id,
    'Inome': nome,
  };
}