import 'package:flutter/material.dart';

ThemeData buildAppTheme() {
  const primary = Color(0xFF6A5AE0);
  const secondary = Color(0xFFEE3EC9);
  const surface = Color(0xFFF7F8FC);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    secondary: secondary,
    surface: surface,
    brightness: Brightness.light,
  );

  return ThemeData(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: surface,
    useMaterial3: true,
    textTheme: const TextTheme(
      displaySmall: TextStyle(fontWeight: FontWeight.w700),
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
      bodyMedium: TextStyle(height: 1.4),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white.withOpacity(0.7),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0), borderSide: BorderSide.none),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(
      color: Colors.white.withOpacity(0.6),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}


