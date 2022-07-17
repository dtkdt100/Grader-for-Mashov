import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/first_settings_card.dart';
import '../../custom_dialog.dart';


class ChangeNameDialog extends CustomDialog<String> {
  ChangeNameDialog() : super(dialog);

  static Name _name = Name.global;

  static String stringByName() =>
      _name == Name.anonymous ? FirstSettingsCardState.anonymous : FirstSettingsCardState.global;

  static Widget selectedButton(String text, setState, Name n) => Theme(
    data: ThemeData(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    ),
    child: Padding(
      padding: const EdgeInsets.only(),
      child: RadioListTile<Name>(
        title: Text(
          text,
          style: const TextStyle(fontSize: 17),
        ),
        value: n,
        dense: true,
        groupValue: _name,
        onChanged: (Name? value) {
          setState(() {
            _name = value!;
          });
        },
      ),
    ),
  );

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: const EdgeInsets.all(16.0),
    content: StatefulBuilder(builder: (context, setState) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('שנה שם', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15,),
          selectedButton(
              FirstSettingsCardState.global,
              setState,
              Name.global),
          selectedButton(FirstSettingsCardState.anonymous, setState, Name.anonymous),
        ],
      );
    }),
    actions: [
      TextButton(
        child: const Text('ביטול'),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: const Text('אישור'),
        onPressed: () {
          Navigator.pop(context, stringByName());
        },
      ),
    ],
  );
}
