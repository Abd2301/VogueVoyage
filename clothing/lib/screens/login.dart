import 'package:clothing/features/text.dart';
import 'package:clothing/screens/userinputmain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing/features/auth.dart';
import 'package:clothing/utils/crypt.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart';

class LoginScreen extends ConsumerWidget {
  late final PageController _pageController; // Declare but don't initialize yet

  LoginScreen({Key? key}) : super(key: key) {
    _pageController = PageController(); // Initialize _pageController in the constructor
  }

    void navigateToHomeOrUserInput(
      BuildContext context, bool isSigningUp, bool isSigningIn) {
    if (isSigningUp) {
      Navigator.pushReplacementNamed(context, '/userinputmain');
    } else if (isSigningIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showToast(message: 'Error occurred');
    }
  }
  // Declare userIdState here
  final userIdState = StateProvider<String>((ref) => '');
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Auth _auth = Auth();
  
  void _navigateToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {



    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.jpeg',
                    width: 200.0,
                    height: 200.0,
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    decoration: InputDecoration(labelText: 'Email'),
                    controller: emailController,
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String email = emailController.text;
                          String password = passwordController.text;

                          User? user = await _auth.signInWithEmailAndPassword(
                              email, password);

                          if (user != null) {
                            String email = user.email ?? "";
                            if (email.isNotEmpty) {
                              showToast(message: 'Signed in: $email');
                              String userId = generateUserIdFromEmail(email);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SkinColorOptions(
                                      userId: userId),
                                ),
                              );
                              navigateToHomeOrUserInput(context, false, true);
                            } else {
                              showToast(message: 'Sign in failed');
                            }
                          }
                        },
                        child: const Text('Login'),
                      ),
                      const SizedBox(width: 25.0),
                      TextButton(
                        onPressed: () async {
                          String email = emailController.text;
                          String password = passwordController.text;

                          User? user = await _auth.signUpWithEmailAndPassword(
                              email, password);

                          if (user != null) {
                            String email = user.email ?? "";
                            if (email.isNotEmpty) {
                              showToast(message: 'Signed up: $email');
                              String userId = generateUserIdFromEmail(email);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SkinColorOptions(
                                      userId: userId),
                                ),
                              );
                              navigateToHomeOrUserInput(context, true, false);
                            } else {
                              showToast(message: 'Sign up failed');
                            }
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

