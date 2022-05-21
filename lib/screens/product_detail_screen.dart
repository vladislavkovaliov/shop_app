import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final productId = routeArgs['id'] as String;

    return Scaffold(
      appBar: AppBar(
        title: Text(productId),
      ),
      body: null,
    );
  }
}
