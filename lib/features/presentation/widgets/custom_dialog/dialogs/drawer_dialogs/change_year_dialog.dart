import 'package:flutter/services.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/loading_page.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pickers/radio_list_tile_picker.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

class ChangeYearDialog extends CustomDialog<String> {
  static GlobalKey<RadioListTilePickerState> selectionKey = GlobalKey();
  static List<String> titles = MashovUtilities.loginData!.userSchoolYears
      .map((e) => e.toString())
      .toList()
      .reversed
      .toList();

  ChangeYearDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('החלף שנה',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 5,
              ),
              const Text('לאיזה שנה ברצונך להתחבר?'),
              RadioListTilePicker(
                key: selectionKey,
                trueFirstIndex: titles
                    .indexOf(MashovUtilities.loginData!.data.year.toString()),
                titles: titles,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: const Text('ביטול'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: const Text('עבור'),
            onPressed: () {
              NavigatorUtilities(LoadingPage(doBefore: () async {
                await SharedPreferencesUtilities.changeYear(
                    int.parse(selectionKey.currentState!.currentTitle()));
                await MashovUtilities.logOut();
              })).pushReplacementWithNoAnimation(context);
            },
          ),
        ],
      );
}
