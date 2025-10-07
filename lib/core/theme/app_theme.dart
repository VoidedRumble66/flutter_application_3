import 'package:flutter/material.dart';

/// Defines the AdoptaAmor color palette that keeps parity with the
/// original application's colors while enabling Material 3 styling.
class AppColors {
  static const Color verde = Color.fromARGB(255, 67, 118, 108);
  static const Color crema = Color.fromARGB(255, 248, 250, 230);
  static const Color cafeClaro = Color.fromARGB(255, 177, 148, 112);
  static const Color cafeRojizo = Color.fromARGB(255, 118, 69, 59);
  static const Color negro = Color.fromARGB(255, 48, 62, 60);
}

class AppTheme {
  const AppTheme._();

  static ThemeData lightTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.verde,
      onPrimary: AppColors.crema,
      secondary: AppColors.cafeRojizo,
      onSecondary: AppColors.crema,
      error: Colors.red,
      onError: Colors.white,
      surface: AppColors.crema,
      onSurface: AppColors.cafeRojizo,
      tertiary: AppColors.cafeClaro,
      onTertiary: AppColors.negro,
      surfaceVariant: AppColors.cafeClaro,
      onSurfaceVariant: AppColors.negro,
      outline: AppColors.cafeClaro,
      shadow: Colors.black54,
      scrim: Colors.black54,
      inverseSurface: AppColors.negro,
      onInverseSurface: AppColors.crema,
      inversePrimary: AppColors.cafeRojizo,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.crema,
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.negro,
        contentTextStyle: const TextStyle(color: AppColors.crema, fontSize: 16),
        behavior: SnackBarBehavior.floating,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.verde,
        foregroundColor: AppColors.crema,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.cafeClaro),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.verde, width: 2),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        surfaceTintColor: AppColors.crema,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.crema,
        selectedColor: AppColors.verde.withOpacity(0.15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        labelStyle: const TextStyle(color: AppColors.negro),
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.negro,
        displayColor: AppColors.negro,
      ),
    );
  }
}
