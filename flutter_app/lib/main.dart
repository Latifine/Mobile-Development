import 'package:flutter/material.dart';
import 'package:app/pages/home.dart';

// Main function
void main() {
  // Run app class
  runApp(const App());
}

// StatelessWidget - Main app
class App extends StatelessWidget {

  // Constructor
  const App({Key? key}) : super(key: key);

  // Override build() method of StatelessWidget
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'The Language Game',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage()
    );
  }

}