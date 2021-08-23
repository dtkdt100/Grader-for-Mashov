import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

class DrawerOptions extends StatelessWidget {
  static Map<String, IconData> drawerOptions = {
    'עמוד הבית': Icons.apps,
    'ציונים': MdiIcons.equalizer,
    'מערכת שעות': MdiIcons.calendar,
    'לוח תוצאות (תחרות ממוצעים)': Icons.equalizer_sharp,
    'שיעורי בית': MdiIcons.homeOutline,
    'הודעות': MdiIcons.emailCheck,
    'אירועי התנהגות': Icons.check_box,
    'מונה אירועים': Icons.check_box_outlined,
    'התאמות': MdiIcons.glasses,
    'התנתקות': MdiIcons.logout,
    'יציאה (ללא התנתקות)': MdiIcons.logout,
  };

  final Function(int) callBack;
  const DrawerOptions({Key? key, required this.callBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(drawerOptions.length + 1, (index) {
        List<String> keys = List<String>.from(drawerOptions.keys);

        if (index == drawerOptions.length) {
          return Divider(
            color: const Color(0xFF03a9f4).withOpacity(SharedPreferencesUtilities.themes.opacity),
            thickness: 0.8,
            height: 0,
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Divider(
              color: const Color(0xFF03a9f4).withOpacity(SharedPreferencesUtilities.themes.opacity),
              thickness: 0.8,
              height: 0,
            ),
            InkWell(
              onTap: () {
                // int wherePop = GraderDrawer.drawerOptions.indexOf('התנתקות');
                // if (!(index == wherePop || index == wherePop + 1)) {
                //   Navigator.pop(context);
                // }

                //pushToAntherPage(index);
                if (!(index == 9 || index == 9 + 1)) {
                  Navigator.pop(context);
                }
                callBack(index);
              },
              child: Container(
                padding:
                const EdgeInsets.only(right: 7, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      keys[index],
                      style: TextStyle(
                          color: index == 3
                              ? const Color(0xffdb3d54)
                              : Colors.black),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Icon(
                      drawerOptions[keys[index]],
                      color: Colors.black54,
                      size: 21,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
