import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridView extends StatelessWidget {
  final bool isShowFavoritesOnly;

  const ProductsGridView({
    Key? key,
    required this.isShowFavoritesOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);
    final products = isShowFavoritesOnly
        ? productsContainer.favoritesItems
        : productsContainer.items;

    return GridView.builder(
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
    );
  }
}
