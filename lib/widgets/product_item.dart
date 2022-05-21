import 'package:flutter/material.dart';

import 'package:shop_app/screens/product_detail_screen.dart';

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

  void handleTap(BuildContext context) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: {
        'id': id,
      },
    );
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (ctx) => ProductDetailScreen(
    //       title: title,
    //     ),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => handleTap(context),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: buildIconButton(theme, Icons.favorite, () {}),
          trailing: buildIconButton(theme, Icons.shopping_cart, () {}),
          backgroundColor: Colors.black87,
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton(
    ThemeData theme,
    IconData icon,
    Function onPressed,
  ) {
    return IconButton(
      onPressed: () => onPressed,
      icon: Icon(icon),
      color: theme.colorScheme.secondary,
    );
  }
}
