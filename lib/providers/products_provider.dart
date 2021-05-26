import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttershopudemy/models/http_exception.dart';
import './product.dart';

//limit bundle to only http features
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

//private variables begin with _
  // var _showFavoritesOnly = false;

  List<Product> get items {
    //[_items] returns a copy of the list and fills it with ...,
    //as list will change
    return [..._items];
  }

  List<Product> get favItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://flutter-update-b5667-default-rtdb.europe-west1.firebasedatabase.app/products.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];

      if (extractedData == null) {
        return;
      }
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProduct(Product product) async {
    //make void to use future function to completion bool for loading indicator
    const url =
        'https://flutter-update-b5667-default-rtdb.europe-west1.firebasedatabase.app/products.json';

    try {
      final response = await http.post(
        (Uri.parse(
          url,
        )),
        //encode json to Product object
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        //use firebase unique ID from the http post call + .then()
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      //_items.insert(0, newProduct); //insert at start of list

      //listens to ChangeNotifierProvider widget in main.dart and updates
      //the relevant widgets
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      //convert from const to final because dynamic id url interpolation
      final url =
          'https://flutter-update-b5667-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
      http.patch(Uri.parse(url),
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update-b5667-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    //store pointer to product to be deleted
    var product = _items[productIndex];

    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      //in case error, revert deletion. OPTIMISTIC UPDATING
      _items.insert(productIndex, product);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    //all OK, delete emergency copy
    product = null;
  }

  Product findById(String id) {
    return _items.firstWhere(
      (prod) => prod.id == id,
    );
  }
}
