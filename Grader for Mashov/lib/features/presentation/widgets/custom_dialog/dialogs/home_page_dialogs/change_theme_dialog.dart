import '../../../../../../utilities/phone/shared_preferences_utilities.dart';
import '../../custom_dialog.dart';


class ChangeThemeDialog extends CustomDialog<String> {
  ChangeThemeDialog() : super(dialog);

  static List<String> names = ['בהיר', 'כהה', 'על פי המערכת'];

  static ThemeApp _theme = ThemeUtilities.castTheme(themeDict[SharedPreferencesUtilities.themeMode]);

  static Widget dialog(BuildContext context, {String? value}) {
    if (true){}
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
      content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
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
                      return RadioListTile<ThemeApp>(
                        activeColor: const Color(0xFF03a9f4),
                        title: Text(
                          names[index],
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        value: ThemeUtilities.getThemeByIndex(index),
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
                                ThemeUtilities.setTheme(_theme);
                                Navigator.pop(context, true);
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
            );
          }
      ),
    );
  }

}

