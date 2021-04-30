import 'package:flutter/material.dart';

//! https://material.io/design/color/the-color-system.html#color-theme-creation
// ! The baseline Material color theme

// ColorScheme.light({Color primary: const Color(0xff6200ee),
// Color primaryVariant: const Color(0xff3700b3),
// Color secondary: const Color(0xff03dac6),
// Color secondaryVariant: const Color(0xff018786),
// Color surface: Colors.white,
// Color background: Colors.white,
// Color error: const Color(0xffb00020),
// Color onPrimary: Colors.white,
// Color onSecondary: Colors.black,
// Color onSurface: Colors.black,
// Color onBackground: Colors.black,
// Color onError: Colors.white,
// Brightness brightness: Brightness.light})

///! A default light blue theme. --> confirmar se é o ColorScheme anterior
final ThemeData lightTheme = ThemeData.light().copyWith(
  colorScheme: ColorScheme(
    primary: const Color(0xff6200ee),
    primaryVariant: const Color(0xff3700b3),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff018786),
    surface: Colors.white,
    background: Colors.white,
    error: const Color(0xffb00020),
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme(
    primary: const Color(0xffbb86fc),
    primaryVariant: const Color(0xff3700B3),
    secondary: const Color(0xff03dac6),
    secondaryVariant: const Color(0xff03dac6),
    surface: const Color(0xff121212),
    background: const Color(0xff121212),
    error: const Color(0xffcf6679),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    onBackground: Colors.white,
    onError: Colors.black,
    brightness: Brightness.dark,
  ),
);

// ColorScheme.dark({Color primary: const Color(0xffbb86fc),
// Color primaryVariant: const Color(0xff3700B3),
// Color secondary: const Color(0xff03dac6),
// Color secondaryVariant: const Color(0xff03dac6),
// Color surface: const Color(0xff121212),
// Color background: const Color(0xff121212),
// Color error: const Color(0xffcf6679),
// Color onPrimary: Colors.black,
// Color onSecondary: Colors.black,
// Color onSurface: Colors.white,
// Color onBackground: Colors.white,
// Color onError: Colors.black,
// Brightness brightness: Brightness.dark})
