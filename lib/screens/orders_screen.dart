import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static String routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: ListView.builder(
        itemBuilder: (ctx, i) {
          return OrderItem(
            order: orders.orders[i],
          );
        },
        itemCount: orders.orders.length,
      ),
      drawer: AppDrawer(),
    );
  }
}
