import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static String routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

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

    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: null,
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => handleRefresh(context),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemBuilder: (_, i) {
              return Column(
                children: [
                  UserProductItem(
                    productId: productsContainer.items[i].id.toString(),
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
      ),
    );
  }
}
