import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:flutter/material.dart';

class LightThemes implements Themes {

  @override
  bool darkMode = false;

  @override
  Color backgroundColor = Colors.white;

  @override
  Color colorAppBar = const Color(0xFF03a9f4);

  @override
  List<Color> colorGradient = [const Color(0xFF03a9f4), Colors.lightBlue[300]!];

  @override
  Color colorPicture = Colors.transparent;

  @override
  double opacity = 1;

  @override
  double opacityIcon = 0.05;

  @override
  double opacityText = 1;

  @override
  ThemeData themeData = ThemeData.light().copyWith(splashFactory: MaterialInkSplash.splashFactory);
}