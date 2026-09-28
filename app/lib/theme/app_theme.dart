import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bege,
      colorScheme: const ColorScheme.light(
        primary: AppColors.azul,
        onPrimary: AppColors.branco,
        secondary: AppColors.azulClaro,
        onSecondary: AppColors.azul,
        surface: AppColors.branco,
        onSurface: Colors.black87,
        outline: AppColors.cinzaQuente,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.azul,
        foregroundColor: AppColors.branco,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.branco,
        elevation: 0,
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: AppColors.cinzaQuente, width: 0.5),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.cinzaQuente),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.azulClaro,
        labelStyle: TextStyle(color: AppColors.azul, fontWeight: FontWeight.w600),
        side: BorderSide.none,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.azul,
          foregroundColor: AppColors.branco,
        ),
      ),
    );
  }
}
