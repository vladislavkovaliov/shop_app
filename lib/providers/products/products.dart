import 'package:flutter/material.dart';
import 'package:shop_app/mocks.dart';
import 'package:shop_app/providers/products/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = products;

  bool isShowFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((x) => x.isFavorite == true).toList();
  }

  void addProduct(Product product) {
    _items.insert(0, product);

    notifyListeners();
  }

  Product getProductById(String id) {
    return _items.firstWhere((x) => x.id == id);
  }

  void updateProduct(String productId, Product product) {
    final productIdx = _items.indexWhere((x) => x.id == productId);

    if (productIdx >= 0) {
      _items[productIdx] = product;
      notifyListeners();
    }
  }

  void deleteProduct(String productId) {
    _items.removeWhere((x) => x.id == productId);

    notifyListeners();
  }
}
