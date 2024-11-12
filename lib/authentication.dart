import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'task_list.dart'; // Navigate to the task list screen after successful login

class AuthenticationScreen extends StatefulWidget {
  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Sign-in function that handles email/password authentication
  Future<void> signIn() async {
    try {
      // Attempt to sign in using Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // If successful, navigate to the task list screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen()),
      );
    } catch (e) {
      // Handle any exceptions/errors that occur during the sign-in process
      print("Error signing in: $e");

      // Check if the error is a network issue
      if (e is FirebaseAuthException) {
        if (e.code == 'network-request-failed') {
          // Show network error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Network error. Please check your internet connection and try again.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          // Show Firebase Authentication error (e.g., wrong credentials)
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error signing in: ${e.message}'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      } else {
        // Show unexpected error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error: ${e.toString()}'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In')),
      body: Center( // This centers the login form on the screen
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10.0,
                  offset: Offset(0, 4), // Adjust shadow position
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ensures container size adapts to content
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16), // Adds space between fields
                TextField(
                  controller: passwordController,
                  obscureText: true, // Hides password text
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 20), // Adds space before the button
                ElevatedButton(
                  onPressed: signIn, // Calls signIn method on press
                  child: Text('Sign In'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
