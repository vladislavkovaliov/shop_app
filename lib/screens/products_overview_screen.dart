import 'package:flutter/material.dart';

import 'package:shop_app/mocks.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = products;

  ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  GridView buildBody() {
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
          id: loadedProducts[index].id,
          imageUrl: loadedProducts[index].imageUrl,
          title: loadedProducts[index].title,
        );
      },
      itemCount: loadedProducts.length,
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('MyShop'),
    );
  }
}
