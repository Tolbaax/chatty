import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_app/shared/styles/colors.dart';

ThemeData light = ThemeData(
  primaryColor: AppColors.darkBlue,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: AppColors.darkBlue.withOpacity(0.7),
      statusBarIconBrightness: Brightness.light,
    ),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 25.0,
      fontWeight: FontWeight.w500,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    selectedItemColor: AppColors.blue,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.white,
    elevation: 20.0,
  ),
  textTheme: const TextTheme(
    bodyText1: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
);
