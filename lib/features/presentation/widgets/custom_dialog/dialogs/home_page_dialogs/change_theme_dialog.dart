import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/themes/dark_themes.dart';
import 'package:grader_for_mashov_new/features/data/themes/light_themes.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

enum ThemeApp { light, dark}

class ChangeThemeDialog extends CustomDialog<String> {
  ChangeThemeDialog() : super(dialog);

  static List<String> names = ['בהיר', 'כהה'];

  static ThemeApp _theme = SharedPreferencesUtilities.themes.darkMode ? ThemeApp.dark : ThemeApp.light;

  static Widget dialog(BuildContext context, {String? value}) {
    if (true){}
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      content: StatefulBuilder(
          builder: (context, setState) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'בחר ערכת צבע',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                      children: List.generate(names.length, (index) {
                        ThemeApp? wawa() {
                          switch (index) {
                            case (0):
                              return ThemeApp.light;
                            case (1):
                              return ThemeApp.dark;
                          }
                          return null;
                        }

                        return RadioListTile<ThemeApp>(
                          activeColor: const Color(0xFF03a9f4),
                          title: Text(
                            names[index],
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                          value: wawa()!,
                          groupValue: _theme,
                          onChanged: (ThemeApp? value) {
                            setState(() {
                              _theme = value!;
                            });
                          },
                        );
                      })),
                  Theme(
                    data: ThemeData(),
                    child: Padding(
                      padding:
                      const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        children: [
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: SizedBox(
                              height: 40,
                              child: TextButton(
                                //color: Color(0xFF03a9f4),
                                child: const Text(
                                  'ביטול',
                                  style:
                                  TextStyle(fontSize: 16),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                          Expanded(
                            flex: 8,
                            child: SizedBox(
                              height: 40,
                              child: TextButton(
                                //color: Color(0xFF03a9f4),
                                child: const Text(
                                  'אישור',
                                  style:
                                  TextStyle(fontSize: 16),
                                ),
                                onPressed: () {
                                  SharedPreferencesUtilities.setTheme(themeDict[_theme]!.toString());
                                  SharedPreferencesUtilities.themes = _theme == ThemeApp.light ? LightThemes() : DarkThemes();
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          const Spacer(
                            flex: 1,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
      ),
    );
  }

}

final themeDict = {
  'dark': ThemeApp.dark,
  ThemeApp.dark: 'dark',
  'light': ThemeApp.light,
  ThemeApp.light: 'light',
};