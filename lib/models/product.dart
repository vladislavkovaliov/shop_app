class Product {
  final String id;

  final String description;
  final String imageUrl;
  final String title;

  final double price;

  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.isFavorite = false,
  });
}
