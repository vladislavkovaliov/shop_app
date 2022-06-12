import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/config.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/products/product.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Products with ChangeNotifier {
  List<Product> _items;

  bool isShowFavoritesOnly = false;

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoritesItems {
    return _items.where((x) => x.isFavorite == true).toList();
  }

  Product getProductById(String id) {
    return _items.firstWhere((x) => x.id == id);
  }

  Future<void> fetchAndSetProduct() async {
    var url = Uri.parse(baseUrl + 'products.json?auth=$authToken');

    try {
      final response = await http.get(url);
      final bodyJson = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 400) {
        throw HttpException(bodyJson['error']);
      }

      final urlUserFavorite =
          Uri.parse(baseUrl + 'userFavorite/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(urlUserFavorite);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];

      bodyJson.forEach((prodId, prodValue) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodValue['title'],
          description: prodValue['description'],
          price: prodValue['price'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId]['isFavorite'],
          imageUrl: prodValue['imageUrl'],
        ));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    var url = Uri.parse(baseUrl + 'products.json?auth=$authToken');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
          },
        ),
      );

      var bodyJson = json.decode(response.body);

      if (response.statusCode >= 400) {
        throw HttpException(bodyJson['error']);
      }

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
      rethrow;
    }
  }

  Future<void> updateProduct(String productId, Product product) async {
    final productIdx = _items.indexWhere((x) => x.id == productId);

    if (productIdx >= 0) {
      try {
        final url =
            Uri.parse(baseUrl + 'products/$productId.json?auth=$authToken');

        final response = await http.patch(
          url,
          body: json.encode(
            {
              'title': product.title,
              'description': product.description,
              'imageUrl': product.imageUrl,
              'price': product.price,
            },
          ),
        );

        var bodyJson = json.decode(response.body);

        if (response.statusCode >= 400) {
          throw HttpException(bodyJson['error']);
        }

        _items[productIdx] = product;

        notifyListeners();
      } catch (error) {
        rethrow;
      }
    }
  }

  Future<void> deleteProduct(String productId) async {
    final existingProductIdx = _items.indexWhere((x) => x.id == productId);
    Product? existingProduct = _items[existingProductIdx];

    final url = Uri.parse(baseUrl + 'products/$productId.json?auth=$authToken');

    _items.removeAt(existingProductIdx);
    notifyListeners();

    final response = await http.delete(url);

    var bodyJson = json.decode(response.body);

    if (response.statusCode >= 400) {
      throw HttpException(bodyJson['error']);
    }

    if (response.statusCode >= 200) {
      _items.insert(existingProductIdx, existingProduct);
      notifyListeners();

      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }
}
