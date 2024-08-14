import 'package:flutter/material.dart';
import 'package:socials/screens/auth-screens/landing.dart';
import 'package:socials/screens/auth-screens/login.dart';
import 'package:socials/screens/auth-screens/signup.dart';
import 'package:socials/screens/home/home.dart';
import 'package:socials/screens/post/create-post.dart';
import 'package:socials/screens/profile/profile.dart';

class AuthNavigation extends StatefulWidget {
  @override
  _AuthNavigationState createState() => _AuthNavigationState();
}

class _AuthNavigationState extends State<AuthNavigation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => Landing(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
      },
    );
  }
}
