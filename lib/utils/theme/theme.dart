import 'package:chat_app/utils/app_colors/app_colors.dart';
import 'package:chat_app/utils/theme/custom_theme/kFloatingActionButtonTheme.dart';
import 'package:chat_app/utils/theme/custom_theme/k_appbar_theme.dart';
import 'package:chat_app/utils/theme/custom_theme/k_text_theme.dart';
import 'package:flutter/material.dart';

class KThemeData{

static ThemeData lightTheme=ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  primaryColor:AppColors.primaryColor,
  scaffoldBackgroundColor:AppColors.bgColor,
  textTheme: KTextTheme.lightTheme,
  appBarTheme: KAppBarTheme.lightTheme,
  floatingActionButtonTheme: KFloatingActionButtonTheme.lightTheme

);

static ThemeData darkTheme=ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor:Colors.white,
    scaffoldBackgroundColor: Colors.black,
  appBarTheme: KAppBarTheme.darkTheme,
  textTheme:KTextTheme.darkTheme,
  floatingActionButtonTheme: KFloatingActionButtonTheme.darkTheme
);


}