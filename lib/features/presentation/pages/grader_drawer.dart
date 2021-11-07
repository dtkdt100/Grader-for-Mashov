import 'dart:io';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/behavior/behavior_count_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/behavior/behavior_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/grades/grades_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/hatamot_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/home_page.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/homework/homework_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/leader_board/screens/leader_board_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/drawer_dialogs/change_year_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/drawer_dialogs/leave_app_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/drawer_dialogs/log_out_dialog.dart';
import 'screens/leader_board/screens/leader_board_first_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/messages/messages_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/table_time_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/drawer_widgets/drawer_options.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/drawer_widgets/mashov_picture.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/drawer_widgets/rate_on_google_play.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/drawer_widgets/top_header.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

class GraderDrawer extends StatefulWidget {
  final int from;

  const GraderDrawer(this.from, {Key? key}) : super(key: key);

  @override
  State<GraderDrawer> createState() => _GraderDrawerState();
}

class _GraderDrawerState extends State<GraderDrawer> {
  final ValueNotifier<String?> filePath =
      ValueNotifier(SharedPreferencesUtilities.filePath);

  @override
  void initState() {
    getPicture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
          children: [
            buildTopHeaderDesign(),
            buildPicture(),
            const SizedBox(
              height: 10,
            ),
            DrawerOptions(callBack: handleTap),
          ],
        ),
      ),
    );
  }

  void handleTap(int index) {
    Widget pageRout = const HomePage();

    switch (index) {
      case (0):
        pageRout = const HomePage();
        break;
      case (1):
        pageRout = const GradesScreen(1);
        break;
      case (2):
        pageRout = const TableTimeScreen(2);
        break;
      case (3):
        pageRout = SharedPreferencesUtilities.connectedToLeaderBoard
            ? const LeaderBoardScreen()
            : const LeaderBoardFirstScreen();
        break;
      case (4):
        pageRout = const HomeworkScreen(4);
        break;
      case (5):
        pageRout = const MessagesScreen(5);
        break;
      case (6):
        pageRout = const BehaviorScreen(6);
        break;
      case (7):
        pageRout = const BehaviorCountScreen(7);
        break;
      case (8):
        pageRout = const HatamotScreen(8);
        break;
      case (9):
        LogOutDialog().showWithAnimation(context);
        break;
      case (10):
        ChangeYearDialog().showWithAnimation(context);
        break;
      case (11):
        LeaveAppDialog().showWithAnimation(context);
        break;
    }
    if (!(index == widget.from || index >= 9)) {
      if (index == 0) {
        MashovUtilities.homePageData.clear();
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const HomePage()),
            (route) => false);
      } else {
        if (widget.from == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => pageRout));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => pageRout));
        }
      }
    }
  }

  Widget buildTopHeaderDesign() => const TopHeader();

  Widget buildPicture() => Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: MashovPicture(
              filePath: filePath,
            ),
          ),
          const Spacer(
            flex: 1,
          ),
          Expanded(
              flex: 5,
              child: Platform.isAndroid
                  ? const RateOnGooglePlay()
                  : const SizedBox()),
        ],
      );

  Future<void> getPicture() async {
    SharedPreferencesUtilities.getPicture();
    filePath.value = SharedPreferencesUtilities.filePath;
    if (SharedPreferencesUtilities.filePath == null) {
      filePath.value = (await MashovUtilities.getPicture()).path;
      SharedPreferencesUtilities.setPicture(filePath.value!);
    }
  }
}
