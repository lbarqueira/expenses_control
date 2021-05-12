import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

//! https://material.io/design/color/the-color-system.html#color-theme-creation
// ! The baseline Material color theme

final ThemeData lightTheme = ThemeData.light().copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal),
    },
  ),
  colorScheme: ColorScheme(
    // A primary color is the color displayed most frequently across your app's screens and components.
    primary: const Color(0xff6200ee), // purple 500
    primaryVariant: const Color(0xff3700b3), // purple 700
    // A secondary color provides more ways to accent and distinguish your product.
    // Having a secondary color is optional, and should be applied sparingly to accent select parts of your UI.
    secondary: const Color(0xff03dac5), // teal 200
    secondaryVariant: const Color(0xff018786),
    // Surface colors affect surfaces of components, such as cards, sheets, and menus.
    // The background color appears behind scrollable content. The baseline background and surface color is #FFFFFF.
    // Error color indicates errors in components, such as invalid text in a text field. The baseline error color is #B00020.
    surface: Colors.white,
    background: Colors.white,
    error: const Color(0xffb00020),
    // Typography and iconography colors - On Colors
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    onBackground: Colors.black,
    onError: Colors.white,
    brightness: Brightness.light,
  ),
);

final ThemeData darkTheme = ThemeData.dark().copyWith(
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.horizontal),
    },
  ),
  colorScheme: ColorScheme(
    primary: const Color(0xffbb86fc),
    primaryVariant: const Color(0xff3700B3),
    secondary: const Color(0xff03dac5),
    //secondaryVariant: const Color(0xff03dac5),
    secondaryVariant: const Color(0xff018786),
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
