import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screen/home_screen.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String email;
  final String paymentMethod;
  final DateTime transactionDate;
  final double pricePaid;
  final VoidCallback onReturn;

  const OrderConfirmationPage({
    super.key,
    required this.email,
    required this.paymentMethod,
    required this.transactionDate,
    required this.pricePaid,
    required this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('yyyy-MM-dd , HH:mm').format(transactionDate.toLocal());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Confirmation'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Remove the back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 100.0),
                  const SizedBox(height: 20),
                  const Text(
                    'Thanks for your order!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'The order confirmation has been sent to $email.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Transaction Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedDate,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  paymentMethod,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Method',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  'Express delivery',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Price Paid',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'RM${pricePaid.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  onReturn();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomeScreen(),
                    ),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFA3D5D4),
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text(
                  'Back to Home',
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
    );
  }
}
