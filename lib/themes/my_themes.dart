import 'package:flutter/material.dart';
import 'package:loksewa/themes/my_colors.dart';

class MyAppThemes {
  static final lightTheme = ThemeData(
    primaryColor: MyColors.lightBlue,
    brightness: Brightness.light,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(brightness: Brightness.dark,background: Colors.red),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.black,
    ),
  );
}
