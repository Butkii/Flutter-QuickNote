import 'package:flutter/material.dart';

// Define a ThemeMode state variable to control the theme mode
ThemeMode themeMode = ThemeMode.light;

// Method to change the theme mode
ThemeMode toggleTheme() {
  if (themeMode == ThemeMode.light) {
    themeMode = ThemeMode.dark;
    return themeMode;
  } else {
    themeMode = ThemeMode.dark;
    return themeMode;
  }
}

ThemeData getTheme() {
  switch (themeMode) {
    case ThemeMode.light:
      return ThemeData(
        // Define your light theme here
        primaryColor: const Color(0xFF7EABFF),
        // Add other theme properties as needed
      );
    case ThemeMode.dark:
      return ThemeData.dark().copyWith(
        // Define your dark theme here
        primaryColor: const Color.fromARGB(255, 25, 33, 49),
        // Add other theme properties as needed
      );
    default:
      return ThemeData(
        // Use the default theme or customize it as needed
        primaryColor: const Color(0xFF7EABFF),
        // Add other theme properties as needed
      );
  }
}
