import 'package:flutter/material.dart';
import 'package:fluttershopudemy/providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;

  ProductsGrid(this.showOnlyFavorites);

  @override
  Widget build(BuildContext context) {
    //connection to listener,generic so Products is specified, climbs until it
    //finds relevant provider that has changed its Products
    final productsData = Provider.of<Products>(context);

    //uses a getter on the provider to get list of <Product>
    // //if ShowFavorites has been selected, ternary operator for them - or all items
    final products = showOnlyFavorites ? productsData.favItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      //if using provider on list or grid items, .value is more efficient
      //as the list or grid items, so the widgets can be recycled and not built
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // removed below as all props available in Product through provider
            // products[i].id,
            // products[i].title,
            // products[i].imageUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
