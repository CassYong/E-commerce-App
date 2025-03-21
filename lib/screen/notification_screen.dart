import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    _markNotificationsAsSeen();
  }

  Future<void> _markNotificationsAsSeen() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final notifications = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('seen', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      doc.reference.update({'seen': true});
    }
  }

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final notificationsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    return notificationsSnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Add the document ID to the data map
      return data;
    }).toList();
  }

  Future<void> _deleteNotification(String notificationId) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .doc(notificationId)
        .delete();

    setState(() {
      // Refresh the notifications after deletion
    });
  }

  Future<void> _confirmDeleteNotification(String notificationId) async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete) {
      _deleteNotification(notificationId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                final timestamp =
                    (notification['timestamp'] as Timestamp).toDate();
                final formattedDate =
                    DateFormat('yyyy-MM-dd , HH:mm').format(timestamp);

                final message = notification['message'].toString();
                final parts = message.split(' Items: ');
                final messagePart = parts[0];
                final itemsPart = parts.length > 1 ? 'Items: ${parts[1]}' : '';

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                messagePart,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (itemsPart.isNotEmpty)
                                Text(itemsPart,
                                    style: const TextStyle(fontSize: 16)),
                              Text('Date: $formattedDate',
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _confirmDeleteNotification(notification['id']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}
