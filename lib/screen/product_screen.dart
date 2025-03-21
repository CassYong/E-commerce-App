import 'package:app_project/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:app_project/services/favorite_service.dart'; // Import FavoriteService class
import 'package:app_project/services/cart_service.dart'; // Import CartService class

class ProductScreen extends StatefulWidget {
  final String id;
  final String imagePath;
  final String name;
  final double originalPrice;
  final double? salePrice; // Optional sale price
  final String details;

  const ProductScreen({
    super.key,
    required this.id,
    required this.imagePath,
    required this.name,
    required this.originalPrice,
    this.salePrice,
    required this.details,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isLiked = false;
  final FavoriteService _favoriteService = FavoriteService();
  final CartService _cartService = CartService(); // Add CartService instance

  @override
  void initState() {
    super.initState();
    _checkIfFavorite();
  }

  // Check if product is already marked as favorite
  void _checkIfFavorite() async {
    List<Product> favorites = await _favoriteService.getFavorites();
    setState(() {
      isLiked = favorites.any((product) => product.name == widget.name);
    });
  }

  // Toggle the favorite status
  void _toggleFavorite() async {
    setState(() {
      isLiked = !isLiked;
    });
    if (isLiked) {
      await _favoriteService.saveFavorite(
        Product(
          id: widget.id,
          imagePath: widget.imagePath,
          name: widget.name,
          price: widget.originalPrice,
          salePrice: widget.salePrice,
          details: widget.details,
        ),
      );
    } else {
      await _favoriteService.removeFavorite(
        Product(
          id: widget.id,
          imagePath: widget.imagePath,
          name: widget.name,
          price: widget.originalPrice,
          salePrice: widget.salePrice,
          details: widget.details,
        ),
      );
    }
  }

  // Add to cart functionality
  void _addToCart() async {
    await _cartService.addToCart(
      Product(
        id: widget.id,
        imagePath: widget.imagePath,
        name: widget.name,
        price: widget.originalPrice,
        salePrice: widget.salePrice,
        details: widget.details,
      ),
    );
    // Optionally, show a Snackbar to notify the user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${widget.name} added to cart')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Product Details',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Image.asset(
                widget.imagePath,
                fit: BoxFit.contain,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.4,
              ),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.salePrice != null) ...[
                        Text(
                          'RM${widget.salePrice!.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 255, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'RM${widget.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromARGB(255, 187, 187, 187),
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ] else ...[
                        Text(
                          'Price: RM${widget.originalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Text(
                        widget.details,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Spacer(),
                      // Add to Cart Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFA3D5D4),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 90, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ), // Use the add to cart function
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 20,
            child: GestureDetector(
              onTap: _toggleFavorite,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
