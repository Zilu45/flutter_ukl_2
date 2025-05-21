import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final String userName;
  const HomePage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Text(
          'Selamat datang, $userName!',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
      ),
    );
  }
}