import 'package:flutter/material.dart';
import 'package:zitate_app/config/colors.dart';

ThemeData myTheme = ThemeData(
    scaffoldBackgroundColor: taupeGrey,
    fontFamily: 'Nunito',
    textTheme: const TextTheme(
      headlineSmall: TextStyle(color: outerSpace),
      titleLarge: TextStyle(color: outerSpace),
      titleMedium: TextStyle(color: outerSpace),
      bodyLarge: TextStyle(color: outerSpace),
    ),
    appBarTheme:
        const AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'Nunito')));
