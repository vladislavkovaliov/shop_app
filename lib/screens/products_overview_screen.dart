import 'package:flutter/material.dart';

import 'package:shop_app/mocks.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/widgets/products_grid_view.dart';

class ProductOverviewScreen extends StatelessWidget {
  static String routeName = '/product-overview';

  final List<Product> loadedProducts = products;

  ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const ProductsGridView(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('MyShop'),
    );
  }
}
