import 'package:flutter/material.dart';
import '../../../../utilities/cloud/mashov_utilities.dart';

enum Name { anonymous, global }


class FirstSettingsCard extends StatefulWidget {
  const FirstSettingsCard({Key? key}) : super(key: key);

  @override
  State<FirstSettingsCard> createState() => FirstSettingsCardState();
}

class FirstSettingsCardState extends State<FirstSettingsCard> {
  static String anonymous = 'אנונימי/ת';
  static String global = MashovUtilities.loginData!.students[0].privateName +
      ' ' +
      MashovUtilities.loginData!.students[0].familyName;

  Name _name = Name.global;

  String stringByName() => _name == Name.anonymous ? anonymous : global;

  TextStyle textStyleMain = const TextStyle(fontSize: 15, letterSpacing: 0.4);



  @override
  Widget build(BuildContext context) {
    return buildFirstSettings();
  }

  Widget buildFirstSettings() => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          selectedButton(global, setState, Name.global),
          selectedButton(anonymous, setState, Name.anonymous),
        ],
      ),
      const SizedBox(height: 22,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("   ממוצע:", style: textStyleMain.copyWith(fontSize: 18)),
          Text("   שכבת גיל:", style: textStyleMain.copyWith(fontSize: 18)),
        ],
      ),
      const SizedBox(height: 15,),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(MashovUtilities.homePageData.avg),
          Text("${MashovUtilities.loginData!.students[0].classCode}'"),
        ],
      ),
      const SizedBox(height: 15,),
    ],
  );

  Widget selectedButton(String text, setState, Name n) => Theme(
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
}
