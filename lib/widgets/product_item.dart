import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;

  // final String description;
  final String imageUrl;
  final String title;

  // final double price;

  // bool isFavorite;

  const ProductItem({
    Key? key,
    required this.id,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
