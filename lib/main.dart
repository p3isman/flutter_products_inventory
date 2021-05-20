import 'package:flutter/material.dart';
import 'package:products/bloc/provider.dart';

import 'package:products/pages/home_page.dart';
import 'package:products/pages/login_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
          theme: ThemeData(primarySwatch: Colors.deepPurple),
          debugShowCheckedModeBanner: false,
          title: 'Products app',
          initialRoute: LoginPage.routeName,
          routes: {
            HomePage.routeName: (context) => HomePage(),
            LoginPage.routeName: (context) => LoginPage(),
          }),
    );
  }
}
