import 'package:flutter/material.dart';
import 'package:shop_app/mocks.dart';
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = products;

  List<Product> get items {
    return [..._items];
  }

  void addProduct(Product product) {
    _items.add(product);

    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((x) => x.id == id);
  }
}
