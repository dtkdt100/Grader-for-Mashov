import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../../utilities/phone/shared_preferences_utilities.dart';

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
    'החלף שנה (ללא התנתקות)': MdiIcons.accountSwitch,
    'יציאה (ללא התנתקות)': MdiIcons.logout,
  };

  final Function(int) callBack;
  DrawerOptions({Key? key, required this.callBack}) : super(key: key);

  final Widget divider = Divider(
    color: Colors.grey.withOpacity(ThemeUtilities.themes.opacity),
    thickness: 0.1,
    height: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(drawerOptions.length + 1, (index) {
        List<String> keys = List<String>.from(drawerOptions.keys);
        if (index == drawerOptions.length) {
          return divider;
        }
        return Column(
          children: <Widget>[
            divider,
            InkWell(
              onTap: () {
                if (index < 9) Navigator.pop(context);
                callBack(index);
              },
              child: buildOneLineDrawer(index, keys[index]),
            ),
          ],
        );
      }),
    );
  }

  Widget buildOneLineDrawer(int index, String key) => Container(
    padding: const EdgeInsets.only(right: 7, top: 10, bottom: 10),
    child: Row(
      children: <Widget>[
        Icon(
          drawerOptions[key],
          color: Colors.black54,
          size: 21,
        ),
        const SizedBox(
          width: 6,
        ),
        Text(
          key,
          style: TextStyle(
              color: index == 3
                  ? const Color(0xffdb3d54)
                  : Colors.black),
        ),
      ],
    ),
  );
}
