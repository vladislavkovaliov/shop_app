import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:http/http.dart' as http;

import 'dart:core';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

const URL = 'https://shop-app-ba21e-default-rtdb.firebaseio.com/';

class OrderItem {
  final String id;

  final double amount;

  final List<CartItem> products;
  final DateTime dataTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dataTime,
  });
}

class Orders with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url = Uri.parse(URL + 'orders.json');

    try {
      final timestamp = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'products': cartProducts
              .map((x) => {
                    'id': x.id,
                    'title': x.title,
                    'quantity': x.quantity,
                    'price': x.price,
                  })
              .toList(),
        }),
      );

      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dataTime: timestamp,
        ),
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
