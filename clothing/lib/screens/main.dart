import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/recos.dart';
import 'package:flutter/material.dart';
import 'user_input.dart';
import 'login.dart';
import 'splash.dart';
import 'home.dart';
import 'package:clothing/utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:clothing/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/utils/image_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SelectionModel()),
        ChangeNotifierProvider(create: (_) => UserIdNotifier()),  
        ChangeNotifierProvider(create: (_) => HomeModel()),  
        ChangeNotifierProvider(create: (_) => RecommendationModel()),
        ChangeNotifierProvider(create: (_) => ImageDataProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vogue Voyage',
      theme: ThemeClass.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => Home(initialPage: 1,),
        '/userinputmain': (context) => MyUserPage(userId:),
      },
    );
  }
}
