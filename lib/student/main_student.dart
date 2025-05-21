import 'package:flutter/material.dart';
import 'student_login.dart'; // Import StudentLogin page

void main() {
  runApp(const StudentApp());
}

class StudentApp extends StatelessWidget {
  const StudentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyUni - Student',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StudentLogin(), // Start with Student Login
    );
  }
}
