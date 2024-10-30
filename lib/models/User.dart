class User {
  final int id;
  final String email;
  final String name;
  User({
    required this.id,
    required this.email,
    required this.name,
  });
  // Método para deserializar o JSON recebido pela API
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Método para serializar o modelo User em JSON, caso necessário
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
