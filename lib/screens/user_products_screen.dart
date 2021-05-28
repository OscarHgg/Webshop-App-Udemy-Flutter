import 'package:flutter/material.dart';
import 'package:fluttershopudemy/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  //private function _ async always returns future, as it allows for other
  //code to run as it does
  Future<void> _refreshProducts(BuildContext context) async {
    //listen: false, because we just want the newest list
    //pass true = filterByUser
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  //FutureBuilder to init product list

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context, listen: true);
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text('Manage products'),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: _refreshProducts(context),
            builder: (ctx, snapshot) =>
                snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        //returns future from named function defined above, could be
                        //with anonymous.
                        //send context with onRefresh because screen is not stateful
                        onRefresh: () => _refreshProducts(context),
                        child: Consumer<Products>(
                          //consumer here to only rebuild this part when updating list
                          builder: (ctx, productsData, _) => Padding(
                            padding: EdgeInsets.all(8),
                            child: ListView.builder(
                              itemCount: productsData.items.length,
                              itemBuilder: (_, i) => Column(
                                children: [
                                  UserProductItem(
                                    productsData.items[i].id,
                                    productsData.items[i].title,
                                    productsData.items[i].imageUrl,
                                  ),
                                  Divider(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )));
  }
}
