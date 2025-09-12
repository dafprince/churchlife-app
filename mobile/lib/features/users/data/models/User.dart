// Étape 1 — Créer le model User

// Pourquoi ?
// Parce que ton backend renvoie du JSON, et Flutter travaille mieux avec des objets.

class User {
  final String id;
  final String name;
  final String email;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Convertir JSON -> Objet User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
    );
  }
  // Permet d'afficher un user dans la console
  // je confirme cela
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }
}
