import 'package:almagest/screens/screens.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productos App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
      },
      theme:
          ThemeData.light().copyWith(scaffoldBackgroundColor: Colors.grey[300]),
    );
  }
}
