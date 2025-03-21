import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notification_screen.dart';

class NotificationsIcon extends StatefulWidget {
  const NotificationsIcon({super.key});

  @override
  _NotificationsIconState createState() => _NotificationsIconState();
}

class _NotificationsIconState extends State<NotificationsIcon> {
  int _unseenCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchUnseenNotifications();
  }

  Future<void> _fetchUnseenNotifications() async {
    int count = await _fetchUnseenNotificationsCount();
    setState(() {
      _unseenCount = count;
    });
  }

  Future<int> _fetchUnseenNotificationsCount() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return 0;

    final unseenNotificationsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('seen', isEqualTo: false)
        .get();

    return unseenNotificationsSnapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NotificationsScreen(),
          ),
        ).then((_) => _fetchUnseenNotifications());
      },
      child: Stack(
        children: [
          const CircleAvatar(
            backgroundColor: Color.fromARGB(255, 206, 197, 219),
            radius: 26,
            child: Icon(Icons.notifications, color: Colors.black),
          ),
          if (_unseenCount > 0)
            Positioned(
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 24,
                  minHeight: 24,
                ),
                child: Center(
                  child: Text(
                    '$_unseenCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
