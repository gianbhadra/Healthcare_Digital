import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primaryTeal = Color(0xFF006D5B);
  static const Color primaryTealDark = Color(0xFF005245);
  static const Color accentTeal = Color(0xFF00897B);
  static const Color lightTealBg = Color(0xFFE2F4F1);
  static const Color iconTeal = Color(0xFF0D7C66);
  
  static const Color background = Color(0xFFF5F8FC);
  static const Color cardBg = Colors.white;
  
  static const Color textDark = Color(0xFF1E293B);
  static const Color textMuted = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color inputBg = Color(0xFFFAFCFE);
  
  static const Color checkboxBg = Color(0xFFDCE6F2);
  static const Color securityBadgeText = Color(0xFF2D5E56);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryTeal,
        primary: AppColors.primaryTeal,
        surface: AppColors.cardBg,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(),
    );
  }
}
