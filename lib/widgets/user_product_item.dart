import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String productId;
  final String productTitle;
  final String productImage;

  const UserProductItem({
    Key? key,
    required this.productId,
    required this.productTitle,
    required this.productImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return ListTile(
      title: Text(productTitle),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(productImage),
      ),
      trailing: SizedBox(
        width: 100.0,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditProductScreen.routeName,
                  arguments: productId,
                );
              },
              icon: const Icon(Icons.edit),
              color: theme.colorScheme.primary,
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(productId);
                } catch (error) {
                  scaffold.hideCurrentSnackBar();
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Deleting failed!",
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: theme.colorScheme.error,
            ),
          ],
        ),
      ),
    );
  }
}
