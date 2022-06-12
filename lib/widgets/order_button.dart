import 'package:flutter/material.dart';

import 'package:shop_app/providers/cart/cart.dart';
import 'package:shop_app/providers/orders/orders.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
    required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ScaffoldMessengerState scaffold = ScaffoldMessenger.of(context);

    return TextButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                updateLoading(true);
                await widget.orders.addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                updateLoading(false);
                widget.cart.clear();
              } catch (error) {
                scaffold.hideCurrentSnackBar();
                scaffold.showSnackBar(
                  SnackBar(
                    content: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
      child: _isLoading
          ? const CircularProgressIndicator()
          : const Text("Order Now"),
    );
  }

  void updateLoading(bool value) {
    setState(() {
      _isLoading = value;
    });
  }
}
