import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsContainer = Provider.of<Products>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('User products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      // body: null,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemBuilder: (_, i) {
            return Column(
              children: [
                UserProductItem(
                  productId: productsContainer.items[i].id,
                  productTitle: productsContainer.items[i].title,
                  productImage: productsContainer.items[i].imageUrl,
                ),
                const Divider(),
              ],
            );
          },
          itemCount: productsContainer.items.length,
        ),
      ),
    );
  }
}
