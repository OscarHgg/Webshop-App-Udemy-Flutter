import 'package:flutter/material.dart';
import 'package:fluttershopudemy/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";

  
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: (orderData.orders.length > 0
          ? ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            )
          : Center(
              child: Text(
                'No orders, bro',
                style: TextStyle(fontSize: 24),
              ),
            )),
    );
  }
}
