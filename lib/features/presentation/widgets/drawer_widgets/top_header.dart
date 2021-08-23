import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 35,
          color: const Color(0xFF03a9f4)
              .withOpacity(SharedPreferencesUtilities.themes.opacity),
        ),
        SizedBox(
          height: 150,
          child: DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      SharedPreferencesUtilities.themes.colorPicture,
                      BlendMode.color),
                  child: Image.asset(
                    'assets/header.png',
                    fit: BoxFit.fill,
                  ))),
        ),
        Center(
          child: Text(
              "ברוך הבא ${MashovUtilities.loginData!.students[0].privateName} ${MashovUtilities.loginData!.students[0].familyName}"
                  " ${MashovUtilities.loginData!.students[0].classCode}'${MashovUtilities.loginData!.students[0].classNum}"),
        ),
      ],
    );
  }
}
