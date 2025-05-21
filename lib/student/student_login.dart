// Add this import for using Text widgets
import 'package:flutter/material.dart';
import 'student_dashboard.dart';

class StudentLogin extends StatefulWidget {
  const StudentLogin({super.key});

  @override
  _StudentLoginState createState() => _StudentLoginState();
}

class _StudentLoginState extends State<StudentLogin> {
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Dummy credentials for testing
  final String dummyStudentId = '123';
  final String dummyPassword = 'pass';

  void _login() {
    if (_formKey.currentState!.validate()) {
      String studentId = _studentIdController.text;
      String password = _passwordController.text;

      // Simple credential check (Replace with real authentication)
      if (studentId == dummyStudentId && password == dummyPassword) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentDashboard()),
        );
      } else {
        // Show error if credentials don't match
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid Student ID or Password')),
        );
      }
    }
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password'),
          content: const Text(
              'Please contact the university administration to reset your password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Light background color for modern look
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Welcome Message
              const Text(
                'Welcome to Somali national university',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Spacing between welcome text and logo

              // University Logo at the top center
              Image.asset(
                'assets/images/university_logo.png', // Replace with your logo path
                height: 100,
              ),
              const SizedBox(height: 30),

              // Login Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // Changes position of shadow
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _studentIdController,
                        decoration: InputDecoration(
                          labelText: 'Student ID',
                          prefixIcon: const Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Student ID';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      TextButton(
                        onPressed: _forgotPassword,
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
