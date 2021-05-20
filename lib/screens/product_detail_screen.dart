import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/cart.dart';
import 'package:fluttershopudemy/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String title;
  // final String imageUrl;

  // ProductDetailScreen(this.title, this.imageUrl);

  static const routeName = "/product-details";
  @override
  Widget build(BuildContext context) {
    //getting info through routes in main
    final productId = ModalRoute.of(context).settings.arguments as String;
    //(context, listen:false) = doesnt update provider after initial
    final loadedProduct = Provider.of<Products>(context).findById(productId);

    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'SEK ${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                Text(
                  'inkl moms',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10,
              ),
              width: double.infinity,
              child: Text(
                loadedProduct.description,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
              child: Icon(
                loadedProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: Colors.black,
                size: 24,
              ),
              elevation: 0,
              onPressed: () {
                loadedProduct.toggleFavorite();
              }),
          FloatingActionButton(
              child: Icon(
                Icons.add,
                color: Colors.black,
                size: 24,
              ),
              elevation: 0,
              onPressed: () {
                cart.addItem(
                  loadedProduct.id,
                  loadedProduct.price,
                  loadedProduct.title,
                );
              }),
        ],
      ),
    );
  }
}
