import 'package:flutter/material.dart';

ThemeData get customLightTheme {
  const primaryColor = Color.fromARGB(255, 253, 208, 0);
  const secondaryColor = Colors.lightGreen;
  return ThemeData.from(
      colorScheme: const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  ));
}

ThemeData get customDarkTheme {
  const primaryColor = Color.fromARGB(255, 253, 208, 0);
  const secondaryColor = Colors.lightGreen;
  return ThemeData.from(
      colorScheme: const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  ));
}
