// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Color(0xFFF5F5F3),
          appBarTheme:
              AppBarTheme(backgroundColor: Colors.teal.shade500, elevation: 0)),
      title: 'Inventaris RT',
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
      },
    );
  }
}
