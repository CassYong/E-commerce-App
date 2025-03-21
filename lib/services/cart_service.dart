import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_project/models/cart_item.dart'; // Import CartItem class
import 'package:app_project/models/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class CartService {
  Future<void> addToCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_cart';
    List<String> cart = prefs.getStringList(userKey) ?? [];

    // Check if the product is already in the cart
    CartItem? existingItem;
    for (var item in cart) {
      CartItem cartItem = CartItem.fromMap(json.decode(item));
      if (cartItem.product.name == product.name) {
        existingItem = cartItem;
        break;
      }
    }

    if (existingItem != null) {
      // If already in cart, increase the quantity
      cart.remove(json.encode(existingItem.toMap()));
      existingItem.quantity++;
      cart.add(json.encode(existingItem.toMap()));
    } else {
      // Otherwise, add new product to the cart
      cart.add(json.encode(CartItem(product: product).toMap()));
    }

    await prefs.setStringList(userKey, cart); // Save the updated cart list
  }

  Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    String userKey = '${user.uid}_cart';
    List<String> cart = prefs.getStringList(userKey) ?? [];
    return cart.map((e) => CartItem.fromMap(json.decode(e))).toList();
  }

  Future<void> removeFromCart(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_cart';
    List<String> cart = prefs.getStringList(userKey) ?? [];
    cart.removeWhere((item) =>
        CartItem.fromMap(json.decode(item)).product.name == product.name);
    await prefs.setStringList(userKey, cart);
  }

  Future<void> updateCartItem(CartItem cartItem) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_cart';
    List<String> cart = prefs.getStringList(userKey) ?? [];

    for (int i = 0; i < cart.length; i++) {
      CartItem existingItem = CartItem.fromMap(json.decode(cart[i]));
      if (existingItem.product.name == cartItem.product.name) {
        cart[i] = json.encode(cartItem.toMap()); // Update quantity
        break;
      }
    }

    await prefs.setStringList(userKey, cart); // Save the updated cart list
  }

  Future<void> removePurchasedItems(List<CartItem> purchasedItems) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_cart';
    List<String> cart = prefs.getStringList(userKey) ?? [];
    print('Cart before removal: $cart'); // Log cart contents before removal

    for (CartItem purchasedItem in purchasedItems) {
      cart.removeWhere((item) =>
          CartItem.fromMap(json.decode(item)).product.name ==
          purchasedItem.product.name);
    }

    print('Cart after removal: $cart'); // Log cart contents after removal
    await prefs.setStringList(userKey, cart); // Save the updated cart list
    print('Cart updated in SharedPreferences');
  }
}
