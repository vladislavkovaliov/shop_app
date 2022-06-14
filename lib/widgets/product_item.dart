import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth/auth.dart';
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

  Future<void> handleFavoriteToggle(
    ScaffoldMessengerState scaffold,
    Product product,
    Auth auth,
  ) async {
    try {
      await product.toggleFavoriteStatus(
        auth.token.toString(),
        auth.userId.toString(),
      );
    } catch (error) {
      scaffold.hideCurrentSnackBar();
      scaffold.showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            textAlign: TextAlign.center,
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void handleShoppingCard(
    ScaffoldMessengerState scaffold,
    Cart cart,
    Product product,
  ) {
    cart.addItem(product.id.toString(), product.price, product.title);

    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      SnackBar(
        content: const Text(
          "Added item to cart!",
          textAlign: TextAlign.center,
        ),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "UNDO",
          onPressed: () {
            cart.removeSingleItem(product.id.toString());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    final theme = Theme.of(context);
    final auth = Provider.of<Auth>(context);
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
          onTap: () => handleTap(context, product.id.toString()),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => buildIconButton(
              scaffold,
              product,
              auth,
              theme,
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              handleFavoriteToggle,
            ),
          ),
          trailing: buildTrailingButton(
            scaffold,
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
    ScaffoldMessengerState scaffold,
    Cart cart,
    Product product,
    ThemeData theme,
    IconData icon,
    Function onPressed,
  ) {
    return IconButton(
      icon: Icon(icon),
      color: theme.colorScheme.secondary,
      onPressed: () => onPressed(scaffold, cart, product),
    );
  }

  IconButton buildIconButton(
    ScaffoldMessengerState scaffold,
    Product product,
    Auth auth,
    ThemeData theme,
    IconData icon,
    Function onPressed,
  ) {
    return IconButton(
      onPressed: () => onPressed(scaffold, product, auth),
      icon: Icon(icon),
      color: theme.colorScheme.secondary,
    );
  }
}
