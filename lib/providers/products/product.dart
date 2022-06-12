import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'dart:core';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

const URL = 'https://shop-app-ba21e-default-rtdb.firebaseio.com/';

class Product with ChangeNotifier {
  final String? id;

  final String description;
  final String imageUrl;
  final String title;

  final double price;

  bool isFavorite;

  Product({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus() async {
    final prevFavoriteStatus = isFavorite;
    final newFavoriteStatus = !prevFavoriteStatus;

    try {
      final url = Uri.parse(URL + 'products/$id.json');

      isFavorite = newFavoriteStatus;
      notifyListeners();

      final response = await http.patch(
        url,
        body: json.encode(
          {
            'isFavorite': newFavoriteStatus,
          },
        ),
      );

      if (response.statusCode >= 400) {
        throw HttpException('Updating is failed.');
      }
    } catch (error) {
      isFavorite = prevFavoriteStatus;
      notifyListeners();

      rethrow;
    }
  }
}
