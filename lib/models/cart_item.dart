import 'dart:convert';

import 'package:app_project/models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  // Method to convert CartItem to a map (for storing in SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'product': json.encode(product.toMap()), // Encode the product to a map
      'quantity': quantity,
    };
  }

  // Method to create CartItem from a map (for loading from SharedPreferences)
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product.fromMap(json.decode(map['product'])),
      quantity: map['quantity'],
    );
  }
}
