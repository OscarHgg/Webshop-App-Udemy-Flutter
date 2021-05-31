import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/cart.dart';
import 'package:fluttershopudemy/providers/product.dart';
import 'package:fluttershopudemy/providers/products_provider.dart';
import 'package:full_screen_image/full_screen_image.dart';
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
      // appBar: AppBar(
      //   title: Text(
      //     "print(" + loadedProduct.title + ");",
      //     style: Theme.of(context).appBarTheme.textTheme.bodyText2,
      //     softWrap: true,
      //   ),
      //   toolbarHeight: 75.0,
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            collapsedHeight: 75,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "print(" + loadedProduct.title + ");",
                style: Theme.of(context).appBarTheme.textTheme.bodyText2,
                softWrap: true,
              ),
              background: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
                    textAlign: TextAlign.center,
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
              SizedBox(
                height: 800,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
