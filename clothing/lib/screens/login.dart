import 'package:clothing/features/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing/features/auth.dart';


class LoginScreen extends StatelessWidget {
  void navigateToHomeOrUserInput(
      BuildContext context, bool isSigningUp, bool isSigningIn) {
    if (isSigningUp) {
      // Navigate to userinputmain.dart
      Navigator.pushReplacementNamed(context, '/userinputmain');
    } else if (isSigningIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showToast(message: 'Error occurred');
    }
  }

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
                    'assets/images/logo.jpeg',
                    width: 200.0,
                    height: 200.0,
                  ),
                  const SizedBox(height: 20.0),
                  // Email TextField
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: emailController,
                  ),
                  const SizedBox(height: 20.0), // Adjust spacing as needed

                  // Password TextField
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20.0), // Adjust spacing as needed

                  // Row with Login and Signup Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // Get email and password from text fields
                          String email = emailController.text;
                          String password = passwordController.text;

                          // Call signInWithEmailAndPassword method
                          User? user = await _auth.signInWithEmailAndPassword(
                              email, password);

                          if (user != null) {
                            // Successfully signed in
                            showToast(message: 'Signed in: ${user.email}');
                            navigateToHomeOrUserInput(
                                context, false, true); // Sign-in successful
                          } else {
                            // Sign in failed
                            showToast(message: 'Sign in failed');
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(width: 25.0), // Adjust spacing as needed

                      // Signup Button
                      TextButton(
                        onPressed: () async {
                          // Get email and password from text fields
                          String email = emailController.text;
                          String password = passwordController.text;

                          // Call signUpWithEmailAndPassword method
                          User? user = await _auth.signUpWithEmailAndPassword(
                              email, password);

                          if (user != null) {
                            // Successfully signed up
                            showToast(message: 'Signed up: ${user.email}');
                            navigateToHomeOrUserInput(
                                context, true, false); // Sign-up successful
                          } else {
                            // Sign up failed
                            showToast(message: 'Sign up failed');
                          }
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
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
