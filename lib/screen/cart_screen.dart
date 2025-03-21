import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'favorite_screen.dart';
import 'profile_screen.dart';
import 'address_screen.dart';
import 'checkout_screen.dart'; // Make sure to import your checkout screen
import 'package:app_project/services/cart_service.dart';
import 'package:app_project/models/cart_item.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int _selectedIndex = 2;
  late Future<List<CartItem>> _cartItemsFuture;
  final CartService _cartService = CartService();
  List<CartItem> _selectedCartItems = [];
  bool _isSelectAll = false;

  String _address = '';
  bool _isAddressFilled = false;

  @override
  void initState() {
    super.initState();
    _cartItemsFuture = _cartService.getCartItems();
    _loadAddress();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(context, _createPageRoute(const HomeScreen()));
        break;
      case 1:
        Navigator.pushReplacement(context, _createPageRoute(const FavoriteScreen()));
        break;
      case 2:
        break;
      case 3:
        Navigator.pushReplacement(context, _createPageRoute(const ProfileScreen()));
        break;
    }
  }

  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }

  void _incrementQuantity(CartItem cartItem) async {
    setState(() {
      cartItem.quantity++;
    });
    await _cartService.updateCartItem(cartItem);
    _calculateTotal();
  }

  void _decrementQuantity(CartItem cartItem) async {
    if (cartItem.quantity > 1) {
      setState(() {
        cartItem.quantity--;
      });
      await _cartService.updateCartItem(cartItem);
      _calculateTotal();
    }
  }

  void _removeFromCart(CartItem cartItem) async {
    setState(() {
      _selectedCartItems.remove(cartItem);
      _cartItemsFuture = _cartService.getCartItems();
    });
    await _cartService.removeFromCart(cartItem.product);
    _calculateTotal();
  }

  void _toggleSelectAll(bool? value, List<CartItem> cartItems) {
    setState(() {
      _isSelectAll = value ?? false;
      if (_isSelectAll) {
        _selectedCartItems = List.from(cartItems);
      } else {
        _selectedCartItems.clear();
      }
    });
    _calculateTotal();
  }

  void _toggleSelectItem(
      bool? value, CartItem cartItem, List<CartItem> cartItems) {
    setState(() {
      if (value == true) {
        _selectedCartItems.add(cartItem);
        if (_selectedCartItems.length == cartItems.length) {
          _isSelectAll = true;
        }
      } else {
        _selectedCartItems.remove(cartItem);
        _isSelectAll = false;
      }
    });
    _calculateTotal();
  }

  double _calculateTotal() {
    return _selectedCartItems.fold(0, (total, cartItem) {
      double price = cartItem.product.salePrice ?? cartItem.product.price;
      return total + (price * cartItem.quantity);
    });
  }

  void _loadAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists && userData['address'] != null) {
        setState(() {
          _address = userData['address'];
          _isAddressFilled = true;
        });
      } else {
        setState(() {
          _isAddressFilled = false;
        });
      }
    }
  }

  void _checkout() {
    if (_selectedCartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please select at least one item to proceed to checkout.'),
        ),
      );
    } else if (!_isAddressFilled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Please fill in your delivery address to proceed to checkout.'),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckoutScreen(
            selectedItems: _selectedCartItems,
          ),
        ),
      ).then((_) {
        setState(() {
          _cartItemsFuture = _cartService.getCartItems();
        });
      });
    }
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
            'Cart',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.black,
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<List<CartItem>>(
        future: _cartItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty!',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              ),
            );
          } else {
            final cartItems = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddressScreen(),
                        ),
                      ).then((_) {
                        _loadAddress(); // Refresh address after returning
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_pin, color: Colors.red),
                              const SizedBox(width: 8.0),
                              Text(
                                _address.isEmpty
                                    ? 'Please fill in your delivery details'
                                    : _address,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 12.0, right: 12, top: 15, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 4.0, right: 15),
                            child: Transform.scale(
                              scale: 1.1,
                              child: Checkbox(
                                value: _isSelectAll,
                                onChanged: (value) =>
                                    _toggleSelectAll(value, cartItems),
                              ),
                            ),
                          ),
                          const Text(
                            'Select All',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: cartItems.map((cartItem) {
                        return Dismissible(
                          key: Key(cartItem.product.id
                              .toString()), // Unique key for each item
                          direction: DismissDirection
                              .endToStart, // Swipe from right to left
                          onDismissed: (direction) {
                            setState(() {
                              _selectedCartItems.remove(cartItem);
                              _cartService.removeFromCart(cartItem.product);
                              _cartItemsFuture = _cartService.getCartItems();
                            });
                            _calculateTotal();
                          },
                          background: Container(
                            color: Colors.red,
                            padding: const EdgeInsets.only(right: 20),
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.delete, color: Colors.white),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Transform.scale(
                                  scale: 1.0,
                                  child: Checkbox(
                                    value:
                                        _selectedCartItems.contains(cartItem),
                                    onChanged: (value) => _toggleSelectItem(
                                        value, cartItem, cartItems),
                                    activeColor:
                                        const Color.fromARGB(255, 126, 190, 189),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Set image corner radius
                                  child: Image.asset(
                                    cartItem.product.imagePath,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      const SizedBox(height: 5),
                                      if (cartItem.product.salePrice !=
                                          null) ...[
                                        Text(
                                          'RM${cartItem.product.salePrice!.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'RM${cartItem.product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ] else ...[
                                        Text(
                                          'RM${cartItem.product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (cartItem.quantity == 1) {
                                                _selectedCartItems
                                                    .remove(cartItem);
                                                _cartService.removeFromCart(
                                                    cartItem.product);
                                                _cartItemsFuture =
                                                    _cartService.getCartItems();
                                              } else {
                                                cartItem.quantity--;
                                                _cartService
                                                    .updateCartItem(cartItem);
                                              }
                                            });
                                            _calculateTotal();
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.grey[300],
                                            child: const Icon(Icons.remove,
                                                color: Colors.black, size: 18),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text('${cartItem.quantity}',
                                            style: const TextStyle(fontSize: 16)),
                                        const SizedBox(width: 5),
                                        InkWell(
                                          onTap: () =>
                                              _incrementQuantity(cartItem),
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.grey[300],
                                            child: const Icon(Icons.add,
                                                color: Colors.black, size: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: RM${_calculateTotal().toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _checkout,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFA3D5D4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text(
                          'Checkout',
                          style: TextStyle(
                            color: Colors.black, // Set the text color to black
                            fontWeight:
                                FontWeight.normal, // Set the text to bold
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
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
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 96, 184, 183),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
