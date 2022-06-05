import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:shop_app/providers/orders/orders.dart' as o;

class OrderItem extends StatefulWidget {
  final o.OrderItem order;

  const OrderItem({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _exanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dataTime),
            ),
            trailing: IconButton(
              icon: Icon(_exanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _exanded = !_exanded;
                });
              },
            ),
          ),
          if (_exanded)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 4.0,
              ),
              height: min(widget.order.products.length * 20.0 + 30, 180),
              child: ListView(
                children: widget.order.products
                    .map(
                      (p) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            p.title,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${p.quantity}x \$${p.price}',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
