import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socials/app-navigator.dart';
import 'package:socials/auth-navigator.dart';
import 'package:socials/screens/post/create-post.dart';
import 'package:socials/screens/profile/profile.dart';
import 'package:socials/utils/auth-provider.dart';
import 'package:socials/utils/data.dart';

import 'screens/auth-screens/login.dart';
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthState()),
        // other providers
      ],
      builder: (context, child) => MaterialApp(
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        title: 'My Flutter App',
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: Consumer<AuthState>(builder: (context, authState, _) {
          return authState.isAuthorized
              ?  ApplicationNavigation()
              : AuthNavigation();
        }),
      ),
    );
  }
}
              // ?  ApplicationNavigation() : AuthNavigation()
