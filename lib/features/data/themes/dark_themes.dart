import 'dart:ui';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:flutter/material.dart';

class DarkThemes implements Themes {

  @override
  bool darkMode = true;

  @override
  Color backgroundColor = Colors.grey[900]!;

  @override
  Color colorAppBar = const Color(0xFF274857);

  @override
  List<Color> colorGradient = const [Color(0xFF274857), Color(0xFF456777)];

  @override
  Color colorPicture = Colors.black87;

  @override
  double opacity = 0.2;

  @override
  double opacityIcon = 0.03;

  @override
  double opacityText = 0.7;

  @override
  ThemeData themeData = ThemeData.dark().copyWith(splashFactory: MaterialInkSplash.splashFactory);

}