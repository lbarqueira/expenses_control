import 'package:flutter/painting.dart';

//? color pallete for the project
//? https://blog.prototypr.io/how-to-design-a-dark-theme-for-your-android-app-3daeb264637
//
//? A primary color is the color displayed most frequently across your app's screens and components.
//? A secondary color provides more ways to accent and distinguish your product.
//? Having a secondary color is optional, and should be applied sparingly to accent select parts of your UI.
//? IMPORTANT: Color Tool - Material Design: https://material.io/resources/color/#!/?view.left=0&view.right=0

class Palette {
  //! Light theme
  //! [600]
  // Primary color
  static const Color kPrimaryColor = Color(0xFF3949ab); //? Indigo[600]
  static const Color kPrimaryColorLight = Color(0xff6f74dd);
  static const Color kPrimaryColorDark = Color(0xff00227b);
  // Secondary or accent color
  static const Color kSecondaryColor = Color(0xFF8e24aa); //? Purple[600]
  static const Color kSecondaryColorLight = Color(0xFFc158dc);
  static const Color kSecondaryColorDark = Color(0xFF5c007a);
  // Background Color:
  static const Color kBackgroundColor = Color(0xFFe8eaf6);

  //! Text & Icons
  static const Color kTextOnPrimary = Color(0xFFFFFFFF);

  //! Dark theme - https://material.io/design/color/dark-theme.html
  //! [200]
  // Primary color - Dark Theme
  static const Color kDarkPrimaryColor = Color(0xff9fa8da); //? Indigo[200]
  static const Color kDarkPrimaryColorLight = Color(0xffd1d9ff);
  static const Color kDarkPrimaryColorDark = Color(0xff6f79a8);
  // Secondary color - Dark Theme
  static const Color kDarkSecondaryColor = Color(0xffce93d8); //? Purple[200]
  static const Color kDarkSecondaryColorLight = Color(0xffffc4ff);
  static const Color kDarkSecondaryColorDark = Color(0xff9c64a6);
  // Background Color:
  static const Color kDarkBackgroundBase = Color(0xFF121212);
  //! Text & Icons
  static const Color kDarkTextOnPrimary = Color(0xFF000000);
}
