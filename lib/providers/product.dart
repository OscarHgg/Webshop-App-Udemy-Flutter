import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    @required this.price,
    this.isFavorite = false,
  });

  void _setFavorite(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();

    final url =
        'https://flutter-update-b5667-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json';
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );
      //OPTIMISTIC UPDATING
      if (response.statusCode >= 400) {
        _setFavorite(oldStatus);
      }
    } catch (error) {
      _setFavorite(oldStatus);
    }
  }
}
