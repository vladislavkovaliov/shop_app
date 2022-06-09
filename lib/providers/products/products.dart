import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/mocks.dart';
import 'package:shop_app/providers/products/product.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Products with ChangeNotifier {
  final List<Product> _items = products;

  bool isShowFavoritesOnly = false;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((x) => x.isFavorite == true).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((x) => x.id == id);
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(
        'https://shop-app-ba21e-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
          },
        ),
      );

      var bodyJson = json.decode(response.body);
      _items.insert(
        0,
        Product(
          id: bodyJson['name'],
          description: product.description,
          title: product.title,
          price: product.price,
          isFavorite: product.isFavorite,
          imageUrl: product.imageUrl,
        ),
      );

      notifyListeners();
    } catch (error) {
      throw error;
    }
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
