import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF6C63FF);
  static const Color secondaryColor = Color(0xFF00D9F5);
  static const Color backgroundColor = Color(0xFF121212);
  static const Color cardColor = Color(0xFF1E1E1E);
  static const Color accentColor = Color(0xFFFF5252);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFF44336);
  static const Color warningColor = Color(0xFFFFD600);
  static const Color textPrimaryColor = Color(0xFFFFFFFF);
  static const Color textSecondaryColor = Color(0xFFB0B0B0);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Themes
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      background: backgroundColor,
      error: errorColor,
      surface: cardColor,
      onPrimary: textPrimaryColor,
      onSecondary: textPrimaryColor,
      onBackground: textPrimaryColor,
      onSurface: textPrimaryColor,
      onError: textPrimaryColor,
    ),
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: const CardTheme(
      color: cardColor,
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    textTheme: GoogleFonts.montserratTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(color: textPrimaryColor),
        bodyMedium: TextStyle(color: textPrimaryColor),
        bodySmall: TextStyle(color: textSecondaryColor),
        labelLarge: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: TextStyle(
          color: textPrimaryColor,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: TextStyle(color: textSecondaryColor),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: textPrimaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: cardColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: textSecondaryColor,
      type: BottomNavigationBarType.fixed,
      elevation: 10,
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: primaryColor,
      inactiveTrackColor: primaryColor.withOpacity(0.3),
      thumbColor: secondaryColor,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
    ),
    iconTheme: const IconThemeData(color: textPrimaryColor, size: 24),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: cardColor,
      contentTextStyle: TextStyle(color: textPrimaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
