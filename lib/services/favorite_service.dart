import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'package:app_project/models/product_model.dart'; // Import Product class
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth

class FavoriteService {
  Future<void> saveFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_favorites';
    List<String> favorites = prefs.getStringList(userKey) ?? [];

    // Avoid duplicate entries
    if (!favorites.any((element) =>
        Product.fromMap(json.decode(element)).name == product.name)) {
      favorites.add(json.encode(product.toMap()));
      await prefs.setStringList(userKey, favorites);
    }
  }

  Future<List<Product>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    String userKey = '${user.uid}_favorites';
    List<String> favorites = prefs.getStringList(userKey) ?? [];
    return favorites.map((e) => Product.fromMap(json.decode(e))).toList();
  }

  Future<void> removeFavorite(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    String userKey = '${user.uid}_favorites';
    List<String> favorites = prefs.getStringList(userKey) ?? [];
    favorites.removeWhere((element) =>
        Product.fromMap(json.decode(element)).name == product.name);
    await prefs.setStringList(userKey, favorites);
  }
}
