import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/cart.dart';
import 'package:fluttershopudemy/screens/cart_screen.dart';
import 'package:fluttershopudemy/screens/orders_screen.dart';
import 'package:provider/provider.dart';

import './providers/products_provider.dart';
import 'package:fluttershopudemy/screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'providers/orders.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Makes Cart and Products available throughout
    //the widget tree
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
        )
      ],
      child: MaterialApp(
        title: 'Shopity',
        theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.teal,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
        },
      ),
    );
  }
}
