import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/auth.dart';
import 'package:fluttershopudemy/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: [
        AppBar(
          title: Text('switch() {',
              style: Theme.of(context).appBarTheme.textTheme.bodyText1,),
          automaticallyImplyLeading: false,
          toolbarHeight: 75.0,
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.shop),
          title: Text('Shop', style: TextStyle(letterSpacing: 2)),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.payment),
          title: Text('Orders', style: TextStyle(letterSpacing: 2)),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.edit),
          title: Text('Your Products', style: TextStyle(letterSpacing: 2)),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProductsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.exit_to_app),
          title: Text('Log out', style: TextStyle(letterSpacing: 2)),
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacementNamed('/');

            Provider.of<Auth>(context, listen: false).logout();
          },
        ),
      ],
    ));
  }
}
