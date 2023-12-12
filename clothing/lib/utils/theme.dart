import 'package:flutter/material.dart';

class ThemeClass {
  static const double kBorderRadius = 8.0;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light().copyWith(
      primary: Colors.black,
      background: Color.fromRGBO(251,244,236,2)
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Set text color to black
      bodyMedium: TextStyle(color: Colors.black),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(
          const Size(100, 55),
        ),
        
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (_) => Color.fromARGB(255, 244, 236, 220),
        ),
        shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
          (_) {
            return RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            );
          },
        ),
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (_) => const TextStyle(fontFamily: 'Satisfy'),
        ),
      ),
    ),
  );
}

class ThemeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeClass.lightTheme,
    );
  }
}
