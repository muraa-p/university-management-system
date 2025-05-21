import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'teacher_dashboard.dart';

class TeacherLogin extends StatefulWidget {
  const TeacherLogin({super.key});

  @override
  _TeacherLoginState createState() => _TeacherLoginState();
}

class _TeacherLoginState extends State<TeacherLogin> {
  final TextEditingController _teacherIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true; // Toggles password visibility
  final supabase = Supabase.instance.client; // Supabase client instance

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      String teacherId = _teacherIdController.text.trim();
      String password = _passwordController.text.trim();

      try {
        // Query Supabase to check teacher credentials
        final response = await supabase
            .from('teachers')
            .select()
            .eq('teacher_id', teacherId)
            .single();

        if (response['password'] == password) {
          // Login successful, navigate to dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TeacherDashboard()),
          );
        } else {
          _showError('Invalid Teacher ID or Password');
        }
      } catch (error) {
        _showError('Invalid Teacher ID or Password');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _forgotPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Forgot Password?'),
          content: const Text('Please contact the administration to reset your password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK', style: TextStyle(color: Colors.deepPurple)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Teacher Login', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.school, size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome, Teacher!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 30),

                  // Teacher ID Field
                  TextFormField(
                    controller: _teacherIdController,
                    decoration: InputDecoration(
                      labelText: 'Teacher ID',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) => value!.isEmpty ? 'Please enter your Teacher ID' : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                  ),
                  const SizedBox(height: 20),

                  // Login Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Login', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // Forgot Password
                  TextButton(
                    onPressed: _forgotPassword,
                    child: const Text('Forgot Password?', style: TextStyle(fontSize: 16, color: Colors.deepPurple)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
