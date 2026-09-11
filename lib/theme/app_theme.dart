import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: Colors.indigo,
      scaffoldBackgroundColor: Colors.blue.shade100,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
        primary: Colors.indigo,
        surface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.white,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFFCFD8DC), // Colors.blueGrey.shade100
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.black26,
      ),
      iconTheme: const IconThemeData(
        color: Colors.indigo,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF5C6BC0),
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF5C6BC0),
        onPrimary: Colors.white,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white,
        onSurfaceVariant: Colors.white70,
        secondary: Color(0xFF5C6BC0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF242424),
        elevation: 4,
        margin: EdgeInsets.all(8),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Color(0xFF2A2A2A),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Color(0xFF1B1B1B),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1B1B1B),
        selectedItemColor: Color(0xFF5C6BC0),
        unselectedItemColor: Colors.white70,
      ),
      dividerTheme: const DividerThemeData(
        color: Colors.white24,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF5C6BC0),
        foregroundColor: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
