import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/leader_board/leader_board_base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/leader_board_dialogs/error_login_dialog.dart';
import 'leader_board_loading_screen.dart';
import 'leader_board_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/buttons/button.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/first_settings_card.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/leader_board_card.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';


class LeaderBoardFirstScreen extends StatefulWidget {
  const LeaderBoardFirstScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardFirstScreenState createState() => _LeaderBoardFirstScreenState();
}

class _LeaderBoardFirstScreenState
    extends LeaderBoardBaseScreen<LeaderBoardFirstScreen> {
  int page = 0;
  GlobalKey<FirstSettingsCardState> keyCard = GlobalKey();

  @override
  Widget? get headerWidget => const Icon(
        Icons.equalizer_sharp,
        size: 120,
        color: Colors.white,
      );

  @override
  Widget? get centerWidget => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            page == 0 ? buildHowItWorksCard() : buildFirstSettingsCard(),
            TextButton(
                onPressed: () {
                  animateOut((){
                    NavigatorUtilities(const LeaderBoardScreen()).pushReplacementWithNoAnimation(context);
                  });
                },
                child: const Text(
                  'היכנס רק כדי לצפות',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
      );

  Widget buildHowItWorksCard() => LeaderBoardCard(
        title: 'איך זה עובד',
        lines: const [
          'התחרה עם כל בתי הספר בארץ, כל הגילאים, למי יש את הממוצע הגובה ביותר!',
          "לכל שכבת גיל, ז' עד יב', יש טבלת תחרויות משלה",
          'יש אפשרות להירשם באנונימיות, להתנתק ולשנות את השם'
        ],
        button: Button(
          context: context,
          text: 'המשך',
          linearGradient: LinearGradient(
            colors: SharedPreferencesUtilities.themes.colorGradient,
          ),
          onTap: () {
            setState(() {
              page = 1;
            });
          },
        ),
      );

  Widget buildFirstSettingsCard() => LeaderBoardCard(
        title: 'הגדרות ראשוניות',
        child: FirstSettingsCard(key: keyCard,),
        button: Button(
          context: context,
          text: 'סיים',
          linearGradient: LinearGradient(
            colors: SharedPreferencesUtilities.themes.colorGradient,
          ),
          onTap: () {
            if (canJoinLeaderBoard()) {
              String name = keyCard.currentState!.stringByName();
              animateOut(() {
                NavigatorUtilities(LeaderBoardLoadingScreen(
                  callBack: (context, out) async {
                    await AvgGameController(MashovUtilities.loginData!.data)
                        .signIn(
                        name,
                        MashovUtilities.loginData!,
                        SharedPreferencesUtilities.loginDetails!,
                        double.parse(MashovUtilities.homePageData.avg)
                    )
                        .then((value) {
                      SharedPreferencesUtilities.setLeaderBoard(true);
                      if (value) {
                        out(() {
                          NavigatorUtilities(const LeaderBoardScreen())
                              .pushReplacementWithNoAnimation(context);
                        });
                      }
                    });
                  },
                )).pushReplacementWithNoAnimation(context);
              });
            }
          },
        ),
      );

  bool canJoinLeaderBoard() {
    if (MashovUtilities.homePageData.avg == 'אין נתונים' || MashovUtilities.loginData!.students[0].classCode == null) {
      ErrorLoginDialog().showWithAnimation(context);
      return false;
    }
    return true;
  }
}
