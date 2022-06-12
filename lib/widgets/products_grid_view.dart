import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool isShowFavoritesOnly;

  const ProductsGridView({
    Key? key,
    required this.isShowFavoritesOnly,
  }) : super(key: key);

  Future<void> handleRefresh(BuildContext context) async {
    try {
      await Provider.of<Products>(context, listen: false).fetchAndSetProduct();
    } catch (error) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('An error occurred!'),
          content: Text(error.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Okay'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    final products = isShowFavoritesOnly
        ? productsContainer.favoritesItems
        : productsContainer.items;

    return RefreshIndicator(
      onRefresh: () => handleRefresh(context),
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemBuilder: (ctx, index) {
          return ChangeNotifierProvider.value(
            value: products[index],
            child: const ProductItem(),
          );
        },
        itemCount: products.length,
      ),
    );
  }
}
