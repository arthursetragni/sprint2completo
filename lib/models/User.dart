class User {
  String id;
  String name;
  String email;
  String? gender;
  String? telephone;
  String? adress;
  dynamic date_of_birth;

  User(
      {required this.id,
      required this.name,
      required this.email,
      this.adress,
      this.gender,
      this.date_of_birth,
      this.telephone});

  // Método para converter JSON para o modelo User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      gender: json['gender'] ?? null,
      telephone: json['telephone'] ?? null,
      adress: json['adress'] ?? null,
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
