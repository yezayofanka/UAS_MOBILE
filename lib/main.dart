// main.dart

import 'package:flutter/material.dart';
import 'login_screen.dart'; // Import halaman login

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Absensi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Set the initial route to LoginPage
    );
  }
}
