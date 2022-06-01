import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart/cart.dart';
import 'package:shop_app/providers/products/product.dart';

import 'package:shop_app/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({
    Key? key,
  }) : super(key: key);

  void handleTap(BuildContext context, String productId) {
    Navigator.of(context).pushNamed(
      ProductDetailScreen.routeName,
      arguments: {
        'id': productId,
      },
    );
  }

  void handleFavoriteToggle(Product product) {
    product.toggleFavoriteStatus();
  }

  void handleShoppingCard(Cart cart, Product product) {
    cart.addItem(product.id, product.price, product.title);
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(
      context,
      listen: false,
    );
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => handleTap(context, product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => buildIconButton(
              product,
              theme,
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              handleFavoriteToggle,
            ),
          ),
          trailing: buildTrailingButton(
            cart,
            product,
            theme,
            Icons.shopping_cart,
            handleShoppingCard,
          ),
          backgroundColor: Colors.black87,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  IconButton buildTrailingButton(
    Cart cart,
    Product product,
    ThemeData theme,
    IconData icon,
    Function onPressed,
  ) {
    return IconButton(
      icon: Icon(icon),
      color: theme.colorScheme.secondary,
      onPressed: () => onPressed(cart, product),
    );
  }

  IconButton buildIconButton(
    Product product,
    ThemeData theme,
    IconData icon,
    Function onPressed,
  ) {
    return IconButton(
      onPressed: () => onPressed(product),
      icon: Icon(icon),
      color: theme.colorScheme.secondary,
    );
  }
}
