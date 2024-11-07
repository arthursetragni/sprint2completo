class User {
  String id;
  String name;
  String email;

  User({required this.id, required this.name, required this.email});

  // Método para converter JSON para o modelo User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 'Id desconhecido',
      name: json['name'] ?? 'Nome desconhecido',
      email: json['email'] ?? 'Email desconhecido',
    );
  }
  // Método para converter nosso modelo para Json
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };
}
