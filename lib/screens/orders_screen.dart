import 'package:flutter/material.dart';
import 'package:fluttershopudemy/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';

//stateful because init state data get
class OrdersScreen extends StatefulWidget {
  static const routeName = "/orders";

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future _ordersFuture;

  Future _returnOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture = _returnOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: AppDrawer(),
        //checking connection state
        body: FutureBuilder(
            future:
            //doesnt allow for new futures in case of unintentional rebuilds  
                _ordersFuture,
            builder: (ctx, dataSnapshot) {
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                if (dataSnapshot.error != null) {
                  //error handling
                  return Center(
                    child: Text('Whack'),
                  );
                } else {
                  //no error
                  return Consumer<Orders>(
                      builder: (ctx, orderData, child) => ListView.builder(
                            itemCount: orderData.orders.length,
                            itemBuilder: (ctx, i) =>
                                OrderItem(orderData.orders[i]),
                          ));
                }
              }
            }));
  }
}
