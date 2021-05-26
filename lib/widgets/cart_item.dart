import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem({this.id, this.productId, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: 20,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text('Do you want to remove all the items?'),
            actions: [
              TextButton(
                child: Text('Nope'),
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
              ),
              TextButton(
                child: Text('Yeaaa'),
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(
          context,
          listen: false,
        ).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(
                  child: Text('$price'),
                ),
              ),
            ),
            title: Text(title),
            subtitle:
                Text('Total: SEK ${(price * quantity).toStringAsFixed(2)}'),
            trailing: //Text('$quantity x'),
                TextButton(
              onPressed: () {
                Provider.of<Cart>(
                  context,
                  listen: false,
                ).removeSingleItem(productId);
              },
              onLongPress: () {
                Provider.of<Cart>(
                  context,
                  listen: false,
                ).addItem(productId, price, title);
              },
              child: CircleAvatar(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text('$quantity X'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
