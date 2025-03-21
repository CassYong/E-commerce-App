import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  Future<List<Map<String, dynamic>>> _fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final ordersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .orderBy('transactionDate', descending: true)
        .get();

    return ordersSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID
      return data;
    }).toList();
  }

  Future<void> _deleteOrder(String orderId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(orderId)
        .delete();
  }

  void _showDeleteConfirmationDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this order?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                await _deleteOrder(orderId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Order deleted successfully')),
                );
                _refreshOrders();
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _refreshOrders() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                final orderId =
                    order['id'] as String? ?? ''; // Ensure order ID is not null
                final transactionDate =
                    (order['transactionDate'] as Timestamp).toDate();
                final formattedDate =
                    DateFormat('yyyy-MM-dd , HH:mm').format(transactionDate);

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: const Color.fromARGB(
                      255, 210, 231, 231),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order Date: $formattedDate',
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                    'Payment Method: ${order['paymentMethod']}',
                                    style: const TextStyle(fontSize: 16)),
                                Text(
                                    'Total: RM${order['pricePaid'].toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 16)),
                                Text('Address: ${order['address']}',
                                    style: const TextStyle(fontSize: 16)),
                                Text('Recipient: ${order['receiver']}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, orderId);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Text('Items:',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                        ...order['items'].map<Widget>((item) {
                          final itemName =
                              item['name'] as String? ?? 'Unknown item';
                          final itemQuantity = item['quantity'] ?? 0;
                          final itemPrice =
                              item['price']?.toStringAsFixed(2) ?? '0.00';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                                '$itemName (x$itemQuantity): RM$itemPrice',
                                style: const TextStyle(fontSize: 16)),
                          );
                        }).toList(),
                      ],
                    ),
                  ), // Set card background to white
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.white, // Set screen background to white
    );
  }
}
