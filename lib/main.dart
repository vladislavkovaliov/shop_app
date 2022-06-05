import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders/orders.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/providers/cart/cart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          fontFamily: "Lato",
          colorScheme: themeData.colorScheme.copyWith(
            primary: Colors.blue,
            secondary: Colors.deepOrange,
          ),
        ),
        initialRoute: ProductOverviewScreen.routeName,
        routes: buildRoutes,
      ),
    );
  }

  Map<String, WidgetBuilder> get buildRoutes {
    return {
      ProductOverviewScreen.routeName: (ctx) => const ProductOverviewScreen(),
      ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
      CartScreen.routeName: (ctx) => const CartScreen(),
      OrdersScreen.routeName: (ctx) => const OrdersScreen(),
    };
  }
}
