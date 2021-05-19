import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static final routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(child: Text('Home Page')),
    );
  }
}
