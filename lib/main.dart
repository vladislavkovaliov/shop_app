import 'package:flutter/material.dart';
import 'package:shop_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "Lato",
        colorScheme: themeData.colorScheme.copyWith(
          primary: Colors.blue,
          secondary: Colors.deepOrange,
        ),
      ),
      home: ProductOverviewScreen(),
    );
  }
}
