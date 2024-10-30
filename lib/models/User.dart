class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  // Método para converter JSON para o modelo User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
