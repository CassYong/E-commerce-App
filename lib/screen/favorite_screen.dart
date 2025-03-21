import 'package:flutter/material.dart';
import 'product_screen.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';
import 'package:app_project/models/product_model.dart';
import 'package:app_project/services/favorite_service.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  List<Product> _favorites = [];
  int _selectedIndex = 1; // Default index for the Favorite screen

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    List<Product> favorites = await _favoriteService.getFavorites();
    setState(() {
      _favorites = favorites;
    });
  }

  // Method to handle navigation on bottom navigation item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Handle navigation with custom animation
    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
            context,
            _createPageRoute(
                const HomeScreen())); // Navigate to Home screen with animation
        break;
      case 1:
        // Stay on the Favorite screen
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            _createPageRoute(
                const CartScreen())); // Navigate to Cart screen with animation
        break;
      case 3:
        Navigator.pushReplacement(
            context,
            _createPageRoute(
                const ProfileScreen())); // Navigate to Profile screen with animation
        break;
    }
  }

  // Function to create custom page route with swipe-up transition
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Define swipe-up transition animation
        const begin = Offset(0.0, 1.0); // Start from the bottom
        const end = Offset.zero; // End at the original position
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _toggleFavorite(Product product) async {
    if (_favorites.any((favorite) => favorite.name == product.name)) {
      await _favoriteService.removeFavorite(product);
    } else {
      await _favoriteService.saveFavorite(product);
    }
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorites yet!'))
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 16, // Spacing between columns
                mainAxisSpacing: 16, // Spacing between rows
                childAspectRatio: 3 / 4, // Aspect ratio for each item
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final product = _favorites[index];
                bool isLiked =
                    _favorites.any((favorite) => favorite.name == product.name);
                return GestureDetector(
                  onTap: () {
                    // Navigate to ProductScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductScreen(
                          id: product.id,
                          imagePath: product.imagePath,
                          name: product.name,
                          originalPrice: product.price,
                          salePrice: product.salePrice,
                          details: product.details,
                        ),
                      ),
                    );
                  },
                  child: Stack(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color:
                            Colors.white, // Set card background color to white
                        elevation: 5, // Optional: Add shadow to the card
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 160,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                image: DecorationImage(
                                  image: AssetImage(product.imagePath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'RM${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              color: isLiked ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _toggleFavorite(
                                    product); // Toggle the heart icon
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), // Set background color of the screen
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex, // Set selected index
        selectedItemColor: const Color.fromARGB(255, 96, 184, 183),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped, // Handle bottom navigation tap
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
