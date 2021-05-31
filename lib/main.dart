import 'package:flutter/material.dart';
import 'package:fluttershopudemy/helpers/custom_route.dart';
import 'package:fluttershopudemy/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './providers/orders.dart';
import 'providers/auth.dart';
import 'screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Makes Cart and Products available throughout
    //the widget tree
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        //climbs up and checks Auth, rebuilds if changed
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (
            ctx,
            auth,
            oldProducts,
          ) =>
              Products(auth.token, auth.userId,
                  oldProducts == null ? [] : oldProducts.items),
          create: null,
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (ctx, auth, oldOrders) => Orders(auth.token,
              oldOrders == null ? [] : oldOrders.orders, auth.userId),
          create: null,
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: '_shopContext',
          theme: ThemeData(
            primarySwatch: Colors.blueGrey,
            accentColor: Colors.brown,
            backgroundColor: Color(0xFFFCFCFC),
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android: CustomPageTransitionBuilder(),
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
            }),
            appBarTheme: AppBarTheme(
              backgroundColor: Color(0xFF30292F),
              elevation: 3.0,
              textTheme: TextTheme(
                bodyText1: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 3.0,
                  fontFamily: 'Anton',
                ),
                bodyText2: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 3.0,
                  fontFamily: 'Anton',
                ),
                headline1: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w100,
                  letterSpacing: 3.0,
                  fontFamily: 'Anton',
                ),
              ),
            ),
            fontFamily: 'Anton',
            textTheme: TextTheme(
                headline1:
                    TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                headline6:
                    TextStyle(fontSize: 24.0, fontStyle: FontStyle.italic),
                bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Lato')),
          ),

          //check auth
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
