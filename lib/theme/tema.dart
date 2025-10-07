import 'package:flutter/material.dart';

class MiTema {
  //PALETA DE COLORES:
  static Color verde = const Color.fromARGB(255, 67, 118, 108);
  static Color crema = const Color.fromARGB(255, 248, 250, 230);
  static Color cafeClaro = const Color.fromARGB(255, 177, 148, 112);
  static Color cafeRojizo = const Color.fromARGB(255, 118, 69, 59);
  static Color negro = const Color.fromARGB(255, 48, 62, 60);

  static ThemeData temaApp(BuildContext context) {
    return ThemeData(
      snackBarTheme: _temaSnack(),
      colorScheme: _esquemaColores(context),
      appBarTheme: _temaAppBar(),
    );
  }

  static ColorScheme _esquemaColores(BuildContext context) {
    return ColorScheme(
      brightness: MediaQuery.platformBrightnessOf(context),
      primary: crema,
      onPrimary: verde,
      secondary: cafeRojizo,
      onSecondary: cafeClaro,
      error: Colors.red,
      onError: Colors.white,
      surface: crema,
      onSurface: cafeRojizo,
    );
  }

  static AppBarTheme _temaAppBar() {
    return AppBarTheme(backgroundColor: verde, foregroundColor: crema);
  }

  static SnackBarThemeData _temaSnack() {
    return SnackBarThemeData(
      backgroundColor: negro,
      contentTextStyle: TextStyle(color: crema, fontSize: 18),
    );
  }
}
