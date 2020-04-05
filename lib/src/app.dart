import 'package:flutter/material.dart';
import 'package:qr_reader/src/pages/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
      ),
      title: 'QR Reader',
      routes: {
        '/': (BuildContext context) => HomePage(),
      },
    );
  }
}
