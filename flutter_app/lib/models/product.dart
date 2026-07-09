class Product {
  const Product({
    required this.id,
    required this.image,
    required this.titre,
    required this.description,
    required this.categorie,
    required this.prix,
  });

  final int id;
  final String image;
  final String titre;
  final String description;
  final String categorie;
  final double prix;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      image: json['image'] as String,
      titre: json['titre'] as String,
      description: json['description'] as String,
      categorie: json['categorie'] as String,
      prix: (json['prix'] as num).toDouble(),
    );
  }
}
