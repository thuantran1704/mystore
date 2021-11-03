import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';

ThemeData theme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "Muli",
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      elevation: 0,
      // ignore: deprecated_member_use
      brightness: Brightness.light,
      iconTheme: IconThemeData(color: Colors.black),
      // ignore: deprecated_member_use
      textTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(color: kTextColor),
      bodyText2: TextStyle(color: kTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      // floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      border: outlineInputBorder,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}
