import 'package:flutter/material.dart';
import './pages/home.dart';

void main() {
  runApp(const WikitudeApp());
}

class WikitudeApp extends StatelessWidget {
  const WikitudeApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Language Game Wikitude',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}
