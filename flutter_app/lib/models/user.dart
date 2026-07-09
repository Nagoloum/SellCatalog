class AppUser {
  const AppUser({
    required this.id,
    required this.email,
    required this.nom,
    required this.prenom,
  });

  final int id;
  final String email;
  final String nom;
  final String prenom;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as int,
      email: json['email'] as String,
      nom: json['nom'] as String,
      prenom: json['prenom'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'nom': nom, 'prenom': prenom};
  }
}
