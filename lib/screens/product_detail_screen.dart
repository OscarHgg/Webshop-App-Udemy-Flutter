import 'package:flutter/material.dart';
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
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Container(
        child: Image.network(
          loadedProduct.imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
