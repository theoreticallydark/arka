import 'package:flutter/material.dart';

/// Accessible, high-contrast color palette optimized for older adults & readability.
class AppColors {
  AppColors._();

  // Primary brand colors (Deep calming teal / slate blue)
  static const Color primary = Color(0xFF0F5A57);
  static const Color primaryLight = Color(0xFFE6F3F2);
  static const Color primaryDark = Color(0xFF083C3A);

  // Accent & Action
  static const Color accent = Color(0xFF1E88E5);
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFEF6C00);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color danger = Color(0xFFC62828);
  static const Color dangerLight = Color(0xFFFFEBEE);

  // Background & Surfaces
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFFFFF);

  // High-Contrast Neutral & Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF718096);
  static const Color textLight = Color(0xFFFFFFFF);

  // Borders & Dividers
  static const Color border = Color(0xFFD1D5DB);
  static const Color borderStrong = Color(0xFF9CA3AF);
  static const Color divider = Color(0xFFE5E7EB);

  // Chip & Selection states
  static const Color chipBackground = Color(0xFFEEF2F6);
  static const Color chipSelectedBackground = Color(0xFF0F5A57);
  static const Color chipSelectedText = Color(0xFFFFFFFF);
}
