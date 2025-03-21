import 'package:app_project/screen/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:app_project/screen/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Art Box',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Login(),
        debugShowCheckedModeBanner: false);
  }
}
