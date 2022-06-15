import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth/auth.dart';
import 'package:shop_app/providers/orders/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/products_overview_screen.dart';
import 'package:shop_app/providers/products/products.dart';
import 'package:shop_app/providers/cart/cart.dart';
import 'package:shop_app/screens/splash_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

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
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products('', '', []),
          update: (ctx, auth, previousProducts) => Products(
            auth.token.toString(),
            auth.userId.toString(),
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', '', []),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token.toString(),
            auth.userId.toString(),
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyShop',
            theme: ThemeData(
              fontFamily: "Lato",
              colorScheme: themeData.colorScheme.copyWith(
                primary: Colors.blue,
                secondary: Colors.deepOrange,
              ),
            ),
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoSignIn(),
                    builder: (ctx, authResultSnapshot) {
                      if (authResultSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const SplashScreen();
                      }
                      return const AuthScreen();
                    },
                  ),
            // initialRoute: auth.isAuth
            //     ? ProductOverviewScreen.routeName
            //     : AuthScreen.routeName,
            routes: buildRoutes,
          );
        },
      ),
    );
  }

  Map<String, WidgetBuilder> get buildRoutes {
    return {
      ProductOverviewScreen.routeName: (ctx) => const ProductOverviewScreen(),
      ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
      CartScreen.routeName: (ctx) => const CartScreen(),
      OrdersScreen.routeName: (ctx) => const OrdersScreen(),
      UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
      EditProductScreen.routeName: (ctx) => const EditProductScreen(),
      AuthScreen.routeName: (ctx) => const AuthScreen(),
    };
  }
}
