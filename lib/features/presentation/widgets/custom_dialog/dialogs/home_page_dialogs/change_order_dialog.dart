import 'dart:math';
import 'package:grader_for_mashov_new/features/data/themes/light_themes.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/new_avg_dialog.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import '../../custom_dialog.dart';

class ChangeOrderDialog extends CustomDialog<String>{
  ChangeOrderDialog() : super(dialog);

  static bool selectAll = true;
  static List<bool> selected = [];
  static List<String> cards = ['ציונים', 'שיעורי בית', 'מערכת שעות', 'תחרות ממוצע ציונים'];

  static Widget dialog(BuildContext context, {String? value}) {


    if (selected.isEmpty) {
      selected = SharedPreferencesUtilities.homePageCards!;
    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "שנה סידור במסך הבית",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "בחר כרטיסים שיוצגו במסך הבית: ",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(
              height: 6,
            ),
            Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: CheckboxListTile(
                activeColor: LightThemes().colorAppBar,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text(
                  "בחר הכל",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                value: selectAll,
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selectAll = !selectAll;
                      selected.replaceRange(0, selected.length,
                          List.generate(cards.length, (index) => true));
                    }
                  });
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: 0,
                  maxHeight: 150,
                  minWidth: MediaQuery.of(context).size.width),
              child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(cards.length, (index) {
                          return CheckboxListTile(
                            activeColor: const Color(0xFF03a9f4),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(cards[index]),
                            value: selected[index],
                            onChanged: (val) {
                              setState(() {
                                selected[index] = val!;
                                if (selected.contains(false)) {
                                  selectAll = false;
                                } else {
                                  selectAll = true;
                                }
                              });
                            },
                          );
                        })),
                  )),
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
             await SharedPreferencesUtilities.setHomePageCards(selected);
             Navigator.pop(context);
          },
          child: const Text('אישור')
        )
      ],
    );
  }
}
