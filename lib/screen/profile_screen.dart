import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'cart_screen.dart';
import 'changepass_screen.dart';
import 'orders_screen.dart';
import 'address_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 3; // Default index for the Profile screen (index 3)

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
        Navigator.pushReplacement(
            context,
            _createPageRoute(
                const FavoriteScreen())); // Navigate to Favorite screen with animation
        break;
      case 2:
        Navigator.pushReplacement(
            context,
            _createPageRoute(
                const CartScreen())); // Navigate to Cart screen with animation
        break;
      case 3:
        // Stay on the Profile screen
        break;
    }
  }

  // Function to create custom page route with swipe-up transition
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from the bottom of the screen
        const end = Offset.zero; // End at the center of the screen
        const curve = Curves.easeInOut; // Apply easing curve

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  // Method to handle logout with confirmation dialog
  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Do you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                // Perform logout logic here (e.g., clear user session, navigate to login screen)
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const Login()), // Navigate to the login screen
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve the current user
    final User? user = FirebaseAuth.instance.currentUser;

    final String email = user?.email ?? 'guest@example.com';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 10.0),
          child: Text(
            'Profile',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFC5DBD6),
                      Color(0xFFB4D7D2),
                      Color(0xFFA3D5D4)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 0.49, 1.0],
                  ),
                ),
                child: Center(
                  child: Text(
                    "User: $email",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: const Text('My Orders'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyOrdersScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Edit Devivery Information'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddressScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.password_rounded),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
            const Divider(),
          ],
        ),
      ),
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
