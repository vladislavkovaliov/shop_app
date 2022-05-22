import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGridView extends StatelessWidget {
  const ProductsGridView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context).items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (ctx, index) {
        return ProductItem(
          id: products[index].id,
          imageUrl: products[index].imageUrl,
          title: products[index].title,
        );
      },
      itemCount: products.length,
    );
  }
}
