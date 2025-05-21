// student_forgot_password_page.dart

import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController _studentIdController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter your Student ID to reset your password:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _studentIdController,
              decoration: InputDecoration(
                labelText: 'Student ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle password reset logic here
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Password reset link sent!'),
                ));
                Navigator.pop(context); // Go back to Login Page
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
