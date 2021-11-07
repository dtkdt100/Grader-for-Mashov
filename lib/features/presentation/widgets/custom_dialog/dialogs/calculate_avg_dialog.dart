import 'dart:math';
import 'package:grader_for_mashov_new/features/data/themes/light_theme.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/new_avg_dialog.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import '../custom_dialog.dart';

class CalculateAvgDialog extends CustomDialog<Map<String, List<dynamic>>?> {
  CalculateAvgDialog() : super(dialog);

  static bool selectAll = true;
  static List<bool> selected = [];
  static bool loading = false;

  static Widget dialog(BuildContext context,
      {Map<String, List<dynamic>>? value}) {
    List<Grade> grades = List<Grade>.from(value!['grades']!);
    List<String> subjects = List<String>.from(value['subjects']!);
    if (selected.isEmpty) {
      selected = List.generate(subjects.length, (index) => true);
    }

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: StatefulBuilder(builder: (context, setState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "אפשרויות מתקדמות",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              "בחר מקצועות שישתתפו בחישוב הממוצע: ",
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
                activeColor: LightTheme().colorAppBar,
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
                          List.generate(subjects.length, (index) => true));
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
                  maxHeight: 250,
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
                        children: List.generate(subjects.length, (index) {
                          return CheckboxListTile(
                            activeColor: const Color(0xFF03a9f4),
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(subjects[index]),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      loading = true;
                      setState(() {});

                      Future.delayed(
                          Duration(milliseconds: 150 + Random().nextInt(450)),
                          () {
                            List<String> avoid = [];
                            for (int i = 0; i < subjects.length; i++) {
                              if (!selected[i]) avoid.add(subjects[i]);
                            }
                            NewAvgDialog().showWithAnimation(context,
                                value: MashovUtilities.calculateAvg(grades,
                                    avoidSub: avoid, fixed: 2));
                            setState((){
                              loading = false;
                            });
                          });

                    },
                    child: !loading
                        ? const Text('חשב/י', style: TextStyle(fontSize: 16, color: Colors.black),)
                        : const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 3.3,
                            color: Colors.black,
                            ),
                        )),
              ],
            )
          ],
        );
      }),
    );
  }
}
