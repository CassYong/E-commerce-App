import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_project/models/cart_item.dart';
import 'address_screen.dart';
import 'confirmation_screen.dart';
import 'package:app_project/services/cart_service.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartItem> selectedItems;

  const CheckoutScreen({super.key, required this.selectedItems});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _address = '';
  String _receiver = '';
  String _phone = '';
  String _selectedPaymentMethod = '';

  @override
  void initState() {
    super.initState();
    _loadAddressInfo();
  }

  void _loadAddressInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        setState(() {
          _address = userData['address'] ?? '';
          _receiver = userData['receiver'] ?? '';
          _phone = userData['phone'] ?? '';
        });
      }
    }
  }

  double _calculateItemsTotal() {
    return widget.selectedItems.fold(0, (total, cartItem) {
      double price = cartItem.product.salePrice ?? cartItem.product.price;
      return total + (price * cartItem.quantity);
    });
  }

  double _calculateTotal() {
    double itemsTotal = _calculateItemsTotal();
    return itemsTotal + 5; // Add RM 5 for delivery fee
  }

  void _confirmPayment() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      String email = user?.email ?? 'your email address';
      DateTime transactionDate =
          DateTime.now(); // Capture the current date and time
      double pricePaid = _calculateTotal(); // Calculate the total price paid

      // Save order details to Firestore
      final orderDetails = {
        'email': email,
        'paymentMethod': _selectedPaymentMethod,
        'transactionDate': transactionDate,
        'pricePaid': pricePaid,
        'address': _address, // Add address
        'receiver': _receiver, // Add recipient name
        'items': widget.selectedItems
            .map((item) => {
                  'name': item.product.name,
                  'quantity': item.quantity,
                  'price': item.product.salePrice ?? item.product.price,
                })
            .toList(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('orders')
          .add(orderDetails);
      print('Order details saved to Firestore');

      // Save notification with item names and seen status
      final itemNames =
          widget.selectedItems.map((item) => item.product.name).join(', ');
      final notification = {
        'message': 'Your order is on the way! Items: $itemNames',
        'timestamp': Timestamp.now(),
        'seen': false,
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .collection('notifications')
          .add(notification);
      print('Notification saved to Firestore');

      // Remove purchased items from cart
      final cartService = CartService();
      await cartService.removePurchasedItems(widget.selectedItems);
      print('Purchased items removed from cart');

      // Navigate to the order confirmation screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationPage(
            email: email,
            paymentMethod: _selectedPaymentMethod,
            transactionDate: transactionDate,
            pricePaid: pricePaid,
            onReturn: () {
              Navigator.pop(
                  context); // Go back to the cart screen and refresh it
            },
          ),
        ),
      );
    } catch (e) {
      print('Error during payment confirmation: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 5), // Adjust padding as needed
                          child: Text(
                            'Delivery Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddressScreen(),
                              ),
                            ).then((_) {
                              _loadAddressInfo(); // Refresh address info after returning
                            });
                          },
                          child: const Text(
                            'Edit',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5),
                      child: Text('Address: $_address',
                          style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5),
                      child: Text('Receiver: $_receiver',
                          style: const TextStyle(fontSize: 16)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2.0, horizontal: 5),
                      child: Text('Phone: $_phone',
                          style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Your Order',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.selectedItems.length,
                itemBuilder: (context, index) {
                  final cartItem = widget.selectedItems[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cartItem.product.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 5),
                              if (cartItem.product.salePrice != null) ...[
                                Text(
                                  'RM${cartItem.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                Text(
                                  'RM${cartItem.product.salePrice!.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ] else ...[
                                Text(
                                  'RM${cartItem.product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                              const SizedBox(height: 5),
                              Text('Quantity: ${cartItem.quantity}',
                                  style: const TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Subtotal:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'RM${_calculateItemsTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery Fee:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    'RM5.00',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'RM${_calculateTotal().toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[100],
                ),
                child: ListTile(
                  leading: const Icon(Icons.credit_card,
                      color: Colors.blue), // Icon for Credit Card
                  title: const Text('Credit Card'),
                  trailing: Radio<String>(
                    value: 'Credit Card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[100],
                ),
                child: ListTile(
                  leading: const Icon(Icons.payment,
                      color: Colors.green), // Icon for Debit Card
                  title: const Text('Debit Card'),
                  trailing: Radio<String>(
                    value: 'Debit Card',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[100],
                ),
                child: ListTile(
                  leading: const Icon(Icons.account_balance_wallet,
                      color: Colors.orange), // Icon for E-Wallet
                  title: const Text('E-Wallet'),
                  trailing: Radio<String>(
                    value: 'E-Wallet',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.grey[100],
                ),
                child: ListTile(
                  leading: const Icon(Icons.attach_money,
                      color: Colors.red), // Icon for Cash on Delivery
                  title: const Text('Cash on Delivery'),
                  trailing: Radio<String>(
                    value: 'Cash on Delivery',
                    groupValue: _selectedPaymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_selectedPaymentMethod.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please select a payment method.'),
                        ),
                      );
                    } else {
                      _confirmPayment();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA3D5D4),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 18),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  child: const Text(
                    'Confirm Payment',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
