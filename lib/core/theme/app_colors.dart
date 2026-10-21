import 'package:flutter/material.dart';

/// Paleta de cores (design tokens) do app.
class AppColors {
  AppColors._();

  // Primary & Brand
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFFEEF2FF);
  static const Color secondary = Color(0xFF0EA5E9);

  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color border = Color(0xFFE2E8F0);

  // Text
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // Priorities
  static const Color priorityHigh = Color(0xFFEF4444);
  static const Color priorityHighBg = Color(0xFFFEF2F2);

  static const Color priorityMedium = Color(0xFFF59E0B);
  static const Color priorityMediumBg = Color(0xFFFFFBEB);

  static const Color priorityLow = Color(0xFF10B981);
  static const Color priorityLowBg = Color(0xFFECFDF5);

  // Categories
  static const Color categoryWork = Color(0xFF3B82F6);
  static const Color categoryStudy = Color(0xFF8B5CF6);
  static const Color categoryPersonal = Color(0xFFEC4899);
  static const Color categoryHealth = Color(0xFF14B8A6);
  static const Color categoryFinance = Color(0xFFF97316);
  static const Color categoryOther = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFF22C55E);
  static const Color danger = Color(0xFFEF4444);
}

