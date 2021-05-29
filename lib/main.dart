import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:products/bloc/provider.dart';

import 'package:products/user_preferences/user_preferences.dart';

import 'package:products/pages/home_page.dart';
import 'package:products/pages/login_page.dart';
import 'package:products/pages/product_page.dart';
import 'package:products/pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new UserPreferences();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set light theme status bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Provider(
      child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.teal),
          debugShowCheckedModeBanner: false,
          title: 'Products app',
          initialRoute: LoginPage.routeName,
          routes: {
            HomePage.routeName: (context) => HomePage(),
            LoginPage.routeName: (context) => LoginPage(),
            ProductPage.routeName: (context) => ProductPage(),
            RegisterPage.routeName: (context) => RegisterPage(),
          }),
    );
  }
}
