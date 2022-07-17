import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:grader_for_mashov_new/main.dart';
import 'package:grader_for_mashov_new/utilities/phone/shared_preferences_utilities.dart';
import '../../features/data/themes/themes.dart';

enum ThemeApp { light, dark, system }

final themeDict = {
  'dark': ThemeApp.dark,
  ThemeApp.dark: 'dark',
  'light': ThemeApp.light,
  ThemeApp.light: 'light',
  'system': ThemeApp.system,
  ThemeApp.system: 'system',
};

class ThemeUtilities {
  static Themes themes = LightTheme();

  static ThemeApp getThemeByIndex(int index) {
    switch (index) {
      case (0):
        return ThemeApp.light;
      case (1):
        return ThemeApp.dark;
      case (2):
        return ThemeApp.system;
    }
    return ThemeApp.light;
  }

  static void setTheme(Object theme) {
    SharedPreferencesUtilities.setTheme(themeDict[theme]!.toString());
    if (theme == ThemeApp.system) {
      theme = getSystemTheme();
    }
    themes = theme == ThemeApp.light ? LightTheme() : DarkTheme();
  }

  static void setThemeString(String mode) {
    setTheme(themeDict[mode]!);
  }

  static void changeBrightness(Brightness brightness) {
    if (SharedPreferencesUtilities.themeMode == themeDict[ThemeApp.system]) {
      themes = brightness == Brightness.light ? LightTheme() : DarkTheme();
    }
  }

  static Themes getTheme(String mode) {
    Object theme = themeDict[mode]!;
    if (theme == ThemeApp.system) {
      theme = getSystemTheme();
    }
    switch (theme) {
      case ThemeApp.dark:
        return DarkTheme();
      case ThemeApp.light:
        return LightTheme();
    }
    return LightTheme();
  }

  static ThemeApp castTheme(dynamic theme) {
    switch (theme) {
      case ThemeApp.dark:
        return ThemeApp.dark;
      case ThemeApp.light:
        return ThemeApp.light;
      case ThemeApp.system:
        return ThemeApp.system;
    }
    return ThemeApp.system;
  }

  static ThemeApp getSystemTheme() {
    if (MediaQuery.of(MyApp.navigatorKey.currentContext!).platformBrightness == Brightness.light) {
      return ThemeApp.light;
    } else {
      return ThemeApp.dark;
    }
  }
}