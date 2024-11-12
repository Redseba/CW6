import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // <-- Import Firebase Core
import 'authentication.dart'; // Import authentication logic
import 'task_list.dart'; // Import task list screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter bindings are initialized
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp()); // Run the app after Firebase is initialized
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthenticationScreen(), // Start with the Authentication screen
    );
  }
}
