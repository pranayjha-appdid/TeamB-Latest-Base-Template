import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color primaryColor = const Color(0xFF644D9F);
Color secondaryColor = const Color(0xFFF5F0BB);
Color backgroundDark = const Color(0xff231F20);
Color backgroundLight = const Color(0xffffffff);
const Color textPrimary = Color(0xff000000);
const Color textSecondary = Color(0xff292929);
Color blue = const Color(0xFF3C88C5);

class CustomTheme {
  static ThemeData light = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundLight,
    hintColor: Colors.grey[700],
    canvasColor: secondaryColor,
    primaryColorLight: secondaryColor,
    splashColor: secondaryColor,
    shadowColor: Colors.grey[600],
    cardColor: Colors.grey[100],
    primaryColor: primaryColor,
    dividerColor: Colors.grey[600],
    primaryColorDark: Colors.black,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: secondaryColor,
      onSecondary: Colors.black,
      error: const Color(0xFFCF6679),
      onError: const Color(0xFFCF6679),
      surface: backgroundLight,
      onSurface: Colors.black,
    ),
    appBarTheme: AppBarTheme(
      surfaceTintColor: Colors.white,
      backgroundColor: backgroundLight,
      actionsIconTheme: IconThemeData(color: backgroundLight),
      iconTheme: IconThemeData(color: backgroundDark),
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.dark),
    ),
    typography: Typography.material2021(),
    fontFamily: "Nunito",
    textTheme: const TextTheme(
      labelLarge: TextStyle(fontWeight: FontWeight.w400, color: textSecondary, fontSize: 20.0),
      labelMedium: TextStyle(fontWeight: FontWeight.w400, color: textSecondary, fontSize: 18.0),
      labelSmall: TextStyle(fontWeight: FontWeight.w400, color: textSecondary, fontSize: 16.0),
      headlineLarge: TextStyle(fontWeight: FontWeight.w600, color: textSecondary, fontSize: 18.0),
      headlineMedium: TextStyle(fontWeight: FontWeight.w500, color: textSecondary, fontSize: 16.0),
      displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
      displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      displaySmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    ),
  );
}
