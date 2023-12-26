import 'package:clothing/features/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clothing/features/auth.dart';
import 'package:clothing/utils/crypt.dart';
import 'package:provider/provider.dart';


class UserIdNotifier extends ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
    notifyListeners();
  }
}

class LoginScreen extends StatelessWidget {
  late final PageController _pageController;

  LoginScreen({Key? key}) : super(key: key) {
    _pageController = PageController();
  }

  void navigateToHomeOrUserInput(BuildContext context, bool isSigningUp, bool isSigningIn) {
    if (isSigningUp) {
      Navigator.pushReplacementNamed(context, '/userinputmain');
    } else if (isSigningIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      showToast(message: 'Error occurred');
    }
  }


  void _navigateToNextPage() {
    _pageController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final Auth _auth = Auth();
  
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

                          User? user = await _auth.signInWithEmailAndPassword(email, password);

                          if (user != null) {
                            String email = user.email ?? "";
                            if (email.isNotEmpty) {
                              showToast(message: 'Signed in: $email');
                              String userId = generateUserIdFromEmail(email);

                              Navigator.pushReplacementNamed(
                                context,
                                '/userinputmain',
                                arguments: {'userId': userId}, // Corrected here
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

                          User? user = await _auth.signUpWithEmailAndPassword(email, password);

                          if (user != null) {
                            String email = user.email ?? "";
                            if (email.isNotEmpty) {
                              showToast(message: 'Signed up: $email');
                              String userId = generateUserIdFromEmail(email);

                              Navigator.pushReplacementNamed(
                                context,
                                '/userinputmain',
                                arguments: {'userId': userId}, // Corrected here
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
