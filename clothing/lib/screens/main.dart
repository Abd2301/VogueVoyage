import 'package:flutter/material.dart';
import 'userinput.dart';
import 'login.dart';
import 'splash.dart';
import 'home.dart';
import 'package:clothing/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clothing/firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,
); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vogue Voyage',
      theme: ThemeClass.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => Home(),
        '/userinput': (context) => UserInputPage(),
        
      },
    );
  }
}
