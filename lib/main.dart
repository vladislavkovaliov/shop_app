import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/providers/products.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData();

    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
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
    };
  }
}
