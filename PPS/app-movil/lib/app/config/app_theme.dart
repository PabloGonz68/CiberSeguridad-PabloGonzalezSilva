// lib/app/config/app_theme.dart
// Tema visual premium de VetClinic — paleta oscura con teal/verde veterinario

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Paleta de colores ─────────────────────────────────────────
  static const Color primaryColor    = Color(0xFF00BFA5);  // Teal 600
  static const Color primaryDark     = Color(0xFF00897B);  // Teal 700
  static const Color primaryLight    = Color(0xFF4DD0C4);  // Teal 300
  static const Color accentColor     = Color(0xFFFF7043);  // Deep Orange (adopciones)
  static const Color backgroundDark  = Color(0xFF0D1117);  // GitHub dark bg
  static const Color surfaceColor    = Color(0xFF161B22);  // GitHub dark surface
  static const Color cardColor       = Color(0xFF1C2128);  // Card bg
  static const Color borderColor     = Color(0xFF30363D);  // Borders
  static const Color textPrimary     = Color(0xFFE6EDF3);  // Text principal
  static const Color textSecondary   = Color(0xFF8B949E);  // Text secundario
  static const Color errorColor      = Color(0xFFFF5252);  // Error red
  static const Color successColor    = Color(0xFF4CAF50);  // Success green

  // ── Gradientes ────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryColor, Color(0xFF00897B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFFE64A19)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF161B22)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── ThemeData ─────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: backgroundDark,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: accentColor,
        surface: surfaceColor,
        error: errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w700, fontSize: 32),
        headlineMedium: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 24),
        titleLarge: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w600, fontSize: 18),
        titleMedium: GoogleFonts.inter(
            color: textPrimary, fontWeight: FontWeight.w500, fontSize: 16),
        bodyLarge: GoogleFonts.inter(color: textPrimary, fontSize: 15),
        bodyMedium: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        labelLarge: GoogleFonts.inter(
            color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      cardTheme: CardTheme(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withOpacity(0.2),
        labelStyle: GoogleFonts.inter(color: textPrimary, fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: borderColor),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: borderColor,
        thickness: 1,
        space: 1,
      ),
    );
  }
}
