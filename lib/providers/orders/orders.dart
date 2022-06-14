import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/config.dart';
import 'package:shop_app/models/cart_item.dart';
import 'package:http/http.dart' as http;

import 'dart:core';
import 'dart:convert';

import 'package:shop_app/models/http_exception.dart';

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
  List<OrderItem> _orders;

  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      final url = Uri.parse(baseUrl + 'orders.json?auth=$authToken');
      final response = await http.get(url);
      var extractedData = {};

      // if BE doesn't have data
      extractedData = response.body == "null" ? {} : json.decode(response.body);

      final List<OrderItem> loadedOrders = [];

      extractedData.forEach((orderId, order) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            amount: order['amount'],
            dataTime: DateTime.parse(order['dateTime']),
            products: (order['products'] as List<dynamic>)
                .map((x) => CartItem(
                    id: x['id'],
                    title: x['title'],
                    quantity: x['quantity'],
                    price: x['price']))
                .toList(),
          ),
        );
      });

      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw HttpException("Orders loading is failed.");
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(baseUrl + 'orders.json?auth=$authToken');

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
