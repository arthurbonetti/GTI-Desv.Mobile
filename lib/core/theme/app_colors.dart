import 'package:flutter/material.dart';

/// Paleta de cores (design tokens) do app — Estética Editorial Suíça (Braun / Linear).
class AppColors {
  AppColors._();

  // Primary & Brand (Tinta grafite profunda e sálvia florestal)
  static const Color primary = Color(0xFF1A2024);
  static const Color primaryLight = Color(0xFFEDF1EE);
  static const Color secondary = Color(0xFF2D5A4C);

  // Backgrounds & Surfaces (Papel pedra quente e marfim claro)
  static const Color background = Color(0xFFF6F5F1);
  static const Color surface = Color(0xFFFDFCFA);
  static const Color surfaceMuted = Color(0xFFEFECE6);
  static const Color border = Color(0xFFE3E0D8);
  static const Color borderStrong = Color(0xFFCBC6BA);

  // Text (Hierarquia tipográfica de alto contraste)
  static const Color textPrimary = Color(0xFF141517);
  static const Color textSecondary = Color(0xFF5C6066);
  static const Color textMuted = Color(0xFF8C9096);

  // Priorities (Tons minerais calibrados, não-neon)
  static const Color priorityHigh = Color(0xFFC83A2B); // Vermelho sinalização Braun
  static const Color priorityHighBg = Color(0xFFFAECE9);

  static const Color priorityMedium = Color(0xFFB86B11); // Âmbar ocre
  static const Color priorityMediumBg = Color(0xFFFBF3E6);

  static const Color priorityLow = Color(0xFF2E6B56); // Verde mineral
  static const Color priorityLowBg = Color(0xFFEAF3EF);

  // Categories (Paleta editorial distinta)
  static const Color categoryWork = Color(0xFF2B4C7E); // Azul cobalto escuro
  static const Color categoryStudy = Color(0xFF5E3A73); // Ameixa editorial
  static const Color categoryPersonal = Color(0xFF9E3B52); // Carmim seco
  static const Color categoryHealth = Color(0xFF2A6B5C); // Pinho profundo
  static const Color categoryFinance = Color(0xFF9C5718); // Bronze queimado
  static const Color categoryOther = Color(0xFF5C6066); // Ardósia

  // Status
  static const Color success = Color(0xFF2E6B56);
  static const Color danger = Color(0xFFC83A2B);
  static const Color snackBarAction = Color(0xFFE8D8B9);
}
