


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Janna'
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
  ),
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 20.0,
    backgroundColor: Colors.white,
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,

  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      color: Colors.black,
      fontFamily: 'Janna',
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),
    subtitle1: TextStyle(
      fontFamily: 'Janna',
      color: Colors.black,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.8,
    ),
    caption: TextStyle(
      fontFamily: 'Janna',
      color: Colors.black,
      letterSpacing: 0.8,

    ),
    subtitle2: TextStyle(
      fontFamily: 'Janna',
      color: Colors.black,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,

    ),

  ),
  fontFamily: 'Janna',
  cardTheme: CardTheme(
    color: Colors.white,
    elevation: 5.0,
    clipBehavior: Clip.antiAliasWithSaveLayer,
  ),
);

ThemeData darkTheme = ThemeData(
  appBarTheme: AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor:  HexColor('#121212'),
      statusBarIconBrightness: Brightness.light,
    ),
    backgroundColor: HexColor('#121212'),
    elevation: 0.0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20.0,
      fontFamily: 'Janna',
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  primarySwatch: defaultColor,
  scaffoldBackgroundColor: HexColor('#121212'),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    elevation: 20.0,
    backgroundColor: HexColor('#121212'),
    selectedItemColor: defaultColor,
    unselectedItemColor: Colors.grey,
  ),
  textTheme: TextTheme(
    bodyText1: TextStyle(
      fontFamily: 'Janna',
      color: Colors.white,
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
    ),

    subtitle1: TextStyle(
      fontFamily: 'Janna',
      color: Colors.white,
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: 0.8,

    ),
    caption: TextStyle(
      fontFamily: 'Janna',
      color: Colors.white,
      letterSpacing: 0.8,

    ),
    subtitle2: TextStyle(
      fontFamily: 'Janna',
      color: Colors.white,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,

    ),

  ),
    fontFamily: 'Janna',
  cardTheme: CardTheme(
    color: HexColor('#121212'),
    elevation: 5.0,
    clipBehavior: Clip.antiAliasWithSaveLayer,
  ),

  inputDecorationTheme: InputDecorationTheme(
    hintStyle: TextStyle(
      color: Colors.grey,
    ),
    labelStyle: TextStyle(
      color: Colors.grey,
    ),
  ),
    hintColor: Colors.grey,

);