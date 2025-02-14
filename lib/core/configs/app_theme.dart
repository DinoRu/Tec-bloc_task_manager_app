import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {


  static final appTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.white,
    brightness: Brightness.light,
    fontFamily: 'Montserrat',
    visualDensity: VisualDensity.adaptivePlatformDensity,
    canvasColor: Colors.transparent,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.background,
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: AppColors.secondBackground,
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme:
      const InputDecorationTheme(border: InputBorder.none),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.kPrimaryColor,
        elevation: 0,
        textStyle: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      )
    )
  );
}