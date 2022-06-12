import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders/orders.dart' show Orders;
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static String routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('An error occurred!'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ProductOverviewScreen.routeName);
                },
                child: const Text('Okay'),
              ),
            ],
          ),
        );
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Your Orders")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (ctx, i) {
                return OrderItem(
                  order: orders.orders[i],
                );
              },
              itemCount: orders.orders.length,
            ),
      drawer: const AppDrawer(),
    );
  }
}
