import 'package:flutter/material.dart';
import 'package:snake/app/snake_content.dart';

void main() {
  runApp(const MySnakeApp());
}

class MySnakeApp extends StatelessWidget {
  const MySnakeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Snake Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          '🐍 SNAKE 🐍',
          style: TextStyle(
            fontSize: 32,
            color: Color(0xFF8A2BE2),
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SnakeContent(),
    );
  }
}
