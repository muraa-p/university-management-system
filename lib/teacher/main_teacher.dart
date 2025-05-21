import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase package
import 'teacher_login.dart'; // Import TeacherLogin page

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is properly initialized for async code

  // Initialize Supabase connection
  await Supabase.initialize(
    url: 'https://gnmydbmouaktchffclbg.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdubXlkYm1vdWFrdGNoZmZjbGJnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDA5MDY3OTgsImV4cCI6MjA1NjQ4Mjc5OH0.COH_k94A9Q0rLGfSJ9bw8qGWhjiFGsC1JoVDU6u8W8Q', // Replace with your Supabase anon/public key
  );

  runApp(const TeacherApp());
}

class TeacherApp extends StatelessWidget {
  const TeacherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyUni - Teacher',
      debugShowCheckedModeBanner: false, // Optional: Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.deepPurple, // Match with your login theme color
      ),
      home: const TeacherLogin(), // Start with Teacher Login
    );
  }
}
