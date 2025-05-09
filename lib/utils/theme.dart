import 'package:flutter/material.dart';

class AppTheme {
  static const primaryColor = Color(0xFF9D8DF1); // Lila pastel azulado
  static const secondaryColor = Color(0xFFFFB1DA); // Rosa pastel
  static const accentColor = Color(0xFFAEE6E6); // Aqua suave
  static const lightBackground = Color(0xFFFDF7FF); // Casi blanco con tono lila
  static const darkBackground = Color(0xFF1E1F23); // Similar al fondo oscuro de ChatGPT
  static const cardDark = Color(0xFF2A2B31); // Tarjeta en dark mode

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBackground,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardTheme(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black12,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.light(
      inversePrimary: darkBackground ,
      primary: primaryColor,
      secondary: secondaryColor,
      background: lightBackground,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.black,
      onSurface: Colors.black87,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBackground,
    primaryColor: primaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: const CardTheme(
      color: cardDark,
      elevation: 4,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    ),
    colorScheme: ColorScheme.dark(
      inversePrimary: lightBackground ,
      primary: primaryColor,
      secondary: secondaryColor,
      background: darkBackground,
      surface: cardDark,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
      onBackground: Colors.white,
      onSurface: Colors.white70,
    ),
  );
}
