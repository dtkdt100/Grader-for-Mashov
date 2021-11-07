import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

enum Avg { yes, no }

class ChangeAvgZerosDialog extends CustomDialog<String> {
  ChangeAvgZerosDialog() : super(dialog);

  static List<String> names = ['כן', 'לא'];

  static Avg _avg = SharedPreferencesUtilities.removeZeros ? Avg.yes :  Avg.no;

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: const EdgeInsets.all(16.0),
    content: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              'הסרת הערות:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 5,),
          const Text("האם ברצונך לחשב ממוצע ללא הערות? \n (הערות מופיעות בGrader כ0)",
            style: TextStyle(fontSize: 15),),
          const SizedBox(height: 10,),
          Column(
              children: List.generate(names.length, (index) {
                Avg? wawa() {
                  switch (index) {
                    case (0):
                      return Avg.yes;
                    case (1):
                      return Avg.no;
                  }
                  return null;
                }

                return RadioListTile<Avg>(
                  activeColor: const Color(0xFF03a9f4),
                  title: Text(
                    names[index],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  value: wawa()!,
                  groupValue: _avg,
                  onChanged: (Avg? value) {
                    setState(() {
                      _avg = value!;
                    });
                  },
                );
              })),
          Theme(
            data: ThemeData(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
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
                          style: TextStyle(fontSize: 16),
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
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          SharedPreferencesUtilities.setZero(_avg == Avg.yes);
                          MashovUtilities.homePageData.clear();
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
      );
    }),
  );
}
