import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add your initialization logic here
    Future.delayed(Duration(seconds: 2), () {
      // Navigate to the login or home screen
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.jpeg',  // Replace 'splash.jpeg' with the actual image file in your assets folder
          width: 200.0,  // Adjust the width as needed
          height: 200.0, // Adjust the height as needed
        ),
      ),
    );
  }
}
