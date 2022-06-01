import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;

  final double price;
  final int quantity;

  const CartItem({
    Key? key,
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 4.0,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            child: FittedBox(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Text('\$$price'),
              ),
            ),
          ),
          title: Text(title),
          subtitle: Text(' Total: \$${(price * quantity)}'),
          trailing: Text('${quantity} x'),
        ),
      ),
    );
  }
}
