import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart/cart.dart';
import 'package:shop_app/providers/orders/orders.dart';
import 'package:shop_app/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static String routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orders = Provider.of<Orders>(context, listen: false);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your cart"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(width: 20.0),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: theme.colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              orders.addOrder(cart.items.values.toList(), cart.totalAmount);
              cart.clear();
            },
            child: const Text("Order Now"),
          ),
          const SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CartItem(
                  id: cart.items.values.toList()[i].id.toString(),
                  productKey: cart.items.keys.toList()[i].toString(),
                  price: cart.items.values.toList()[i].price,
                  title: cart.items.values.toList()[i].title,
                  quantity: cart.items.values.toList()[i].quantity,
                );
              },
              itemCount: cart.itemCount,
            ),
          ),
        ],
      ),
    );
  }
}
