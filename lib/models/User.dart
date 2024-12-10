class User {
  String id;
  String name;
  String email;
  String? gender;
  String? telephone;
  String? adress;
  DateTime? date_of_birth;

  User({required this.id, required this.name, required this.email, this.adress, this.gender,this.date_of_birth,this.telephone});

  // Método para converter JSON para o modelo User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? 'Id desconhecido',
      name: json['name'] ?? 'Nome desconhecido',
      email: json['email'] ?? 'Email desconhecido',
      gender: json['gender'] ?? 'Gênero desconhecido',
      telephone: json['telephone'] ?? 'Telefone desconhecido',
      adress: json['adress'] ?? 'Endereço desconhecido',
      date_of_birth: json['date_of_birth'],
    );
  }
  // Método para converter nosso modelo para Json
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'email': email,
        'gender': gender,
        'telephone': telephone,
        'adress': adress,
        'date_of_birth': date_of_birth,
      };
}
