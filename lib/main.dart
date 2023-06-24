import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/signin_screen.dart';
import 'package:news/screens/profile.dart';
import 'package:news/screens/home_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
    routes: {
      '/login': (context) => const SignInScreen(), // Home route (sign-in page)
      '/profile': (context) => ProfilePage(), // Profile rout
      '/home': (context) => const HomeScreen(), // Profile rout

    }
    );
  }
}