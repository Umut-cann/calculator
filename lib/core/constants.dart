import 'package:flutter/material.dart';

class AppConstants {
  // Text styles - constant text styles that can be reused throughout the app
  static const TextStyle titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 20,
    letterSpacing: 0.5,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle buttonTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 18,
    fontFamily: 'Roboto',
  );
  
  static const TextStyle resultTextStyle = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    fontFamily: 'Roboto',
  );
  
  // Common paddings and margins
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const EdgeInsets keypadPadding = EdgeInsets.all(12.0);
  
  // Common border radius values
  static const double defaultRadius = 12.0;
  static const double largeRadius = 24.0;
  
  // Common durations for animations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  
  // App theme colors - Green and white tones
  static const Color primaryColor = Color(0xFF2E7D32);     // Dark green
  static const Color secondaryColor = Color(0xFF4CAF50);   // Medium green
  static const Color accentColor = Color(0xFF8BC34A);      // Light green
  
  // Light theme colors with green and white tones
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme:const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background: Colors.white,
      surface:  Color(0xFFF5F5F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.black87,
      onSurface: Colors.black87,
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
  
  // Dark theme colors with green tones
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      tertiary: accentColor,
      background:  Color(0xFF121212),
      surface:  Color(0xFF1E1E1E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor:  Color(0xFF1E1E1E),
      elevation: 0,
      centerTitle: true,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF262626),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );
}
