import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    //return copy of Map with {} and fill with ... spread operator
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      //product item already exists, change quantity
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        //create new CartItem
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    //always notify listeners to get info up flagpole
    notifyListeners();
  }

  void removeItem(String productId) {
    
    // if (_items.containsKey(productId)) {
    //   //product item already exists, change quantity
    //   _items.update(
    //     productId,
    //     (existingCartItem) => CartItem(
    //       id: existingCartItem.id,
    //       title: existingCartItem.title,
    //       price: existingCartItem.price,
    //       quantity: existingCartItem.quantity - 1,
    //     ),
    //   );
    // } else {}
    //always notify listeners to get info up flagpole
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              price: existingCartItem.price,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
