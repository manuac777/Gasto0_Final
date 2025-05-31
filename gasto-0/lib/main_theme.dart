import 'package:flutter/material.dart';
import 'package:gasto_0/core/const.dart';

ThemeData mainTheme = ThemeData(
  primaryColor: primaryColor,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: primaryColor,
  ),
  useMaterial3: true,
);
