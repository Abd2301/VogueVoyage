import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing/features/auth.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final Auth _auth = Auth();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Centered Container with Login Content

          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your Logo or Image
                  Image.asset(
                    'assets/images/velvetLogo.jpeg',
                    width: 200.0,
                    height: 200.0,
                  ),
                  SizedBox(height: 20.0),
                  // Add your login form fields here (text fields, etc.)
                  // ...

                  // Centered Row with Login and Signup Buttons
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Email TextField
                  TextField(
                   decoration: InputDecoration(labelText: 'Email'),
                    ),
                   SizedBox(height: 20.0), // Adjust spacing as needed

                  // Password TextField
                 TextField(
                  obscureText: true,
                   decoration: InputDecoration(labelText: 'Password'),
                  ),
                 SizedBox(height: 20.0), // Adjust spacing as needed
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                          onPressed: () async {
                          // Get email and password from text fields
                          String email = emailController.text;
                          String password = passwordController.text;
                          // Call signInWithEmailAndPassword method
                          User? user = await _auth.signInWithEmailAndPassword(email, password);

                               if (user != null) {
                             // Successfully signed in, you can navigate to the main page or do other actions
                             print('Signed in: ${user.email}');
                              } else {
                             // Sign in failed
                             print('Sign in failed');
                             }
                           },
                           child: Text('Login'),
                          ),
                            SizedBox(width: 25.0), // Adjust spacing as needed
                            // Signup Button
                            TextButton(
                              onPressed: () async {
                                // Get email and password from text fields
                                String email = 'user@email.com'; // Replace with actual value
                                String password = 'password123'; // Replace with actual value

                                // Call signUpWithEmailAndPassword method
                                User? user = await _auth.signUpWithEmailAndPassword(email, password);

                                if (user != null) {
                               // Successfully signed up, you can navigate to the main page or do other actions
                                print('Signed up: ${user.email}');
                                } else {
                                 // Sign up failed
                                print('Sign up failed');
                                 }
                                },
                                 child: Text('Sign Up'),
                                 ),
                                 ],
                              ),
                            ],
                         ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
