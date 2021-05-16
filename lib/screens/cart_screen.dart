import 'package:flutter/material.dart';
//only item we care about, no name clash with CartItem
import 'package:fluttershopudemy/providers/cart.dart' show Cart;
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: TextStyle(fontSize: 20, ),
                ),
                Spacer(),
                Chip(
                  label: Text(
                    '${cart.totalAmount.toStringAsFixed(2)} SEK',
                    style: TextStyle(
                      color: Theme.of(context).primaryTextTheme.headline6.color,
                    ),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                FlatButton(
                  child: Text('ORDER NOW'),
                  onPressed: () {
                    Provider.of<Orders>(
                      context,
                      listen: false,
                    ).addOrder(
                      cart.items.values.toList(),
                      cart.totalAmount,
                    );

                    cart.clearCart();
                  },
                  textColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                id: cart.items.values.toList()[i].id,
                //product map key = productId
                productId: cart.items.keys.toList()[i],
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
