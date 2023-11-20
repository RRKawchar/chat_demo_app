import 'package:flutter/material.dart';

class KAppBarTheme {
  static AppBarTheme lightTheme = const AppBarTheme(
    backgroundColor: Colors.lightBlueAccent,
    centerTitle: true,
    elevation: 1,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.black,
    ),
  );

  static AppBarTheme darkTheme = const AppBarTheme();
}
