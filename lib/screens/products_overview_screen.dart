import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/mocks.dart';
import 'package:shop_app/providers/cart/cart.dart';
import 'package:shop_app/providers/products/product.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid_view.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  static String routeName = '/product-overview';

  const ProductOverviewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  final List<Product> loadedProducts = products;

  bool isShowFavoritesOnly = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      try {
        setState(() {
          _isLoading = true;
        });
        Provider.of<Products>(context).fetchAndSetProduct().then((_) {
          setState(() {
            _isLoading = false;
          });
        });
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

    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGridView(isShowFavoritesOnly: isShowFavoritesOnly),
      drawer: const AppDrawer(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('MyShop'),
      actions: [
        PopupMenuButton(
          onSelected: (FilterOptions filterOption) {
            switch (filterOption) {
              case FilterOptions.favorites:
                setState(() {
                  isShowFavoritesOnly = true;
                });
                break;
              case FilterOptions.all:
              default:
                setState(() {
                  isShowFavoritesOnly = false;
                });
                break;
            }
          },
          icon: const Icon(Icons.more_vert),
          itemBuilder: (_) => [
            const PopupMenuItem(
              value: FilterOptions.favorites,
              child: Text("Favorites"),
            ),
            const PopupMenuItem(
              value: FilterOptions.all,
              child: Text("All"),
            ),
          ],
        ),
        Consumer<Cart>(
          builder: (_, cart, _child) => Badge(
            child: _child!,
            value: cart.itemCount.toString(),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ),
      ],
    );
  }
}
