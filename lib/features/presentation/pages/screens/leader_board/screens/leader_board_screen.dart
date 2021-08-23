import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/leader_board_screen/leader_board_header.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/leader_board_screen/leader_board_positions.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/leader_board_screen/leader_board_selection.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final GlobalKey<LeaderBoardHeaderState> _headerKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, List<Map<String, dynamic>>?> listAll = {};
  late String currentAgeGroup;

  @override
  void initState() {
    if (MashovUtilities.loginData!.students[0].classCode == null) {
      currentAgeGroup = LeaderBoardSelectionState.options.first;
    } else {
      currentAgeGroup = MashovUtilities.loginData!.students[0].classCode!;
    }
    getLeaderBoard(currentAgeGroup);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: const GraderDrawer(3),
        body: Stack(
          children: [
            swipeDetector(listAll[currentAgeGroup] == null
                ? loading()
                : LeaderBoardPositions(
                    listAll[currentAgeGroup]!,
                    isAll: currentAgeGroup == 'כללי',
                  )),
            LeaderBoardHeader(
              scaffoldKey: _scaffoldKey,
              key: _headerKey,
              restart: (){
                setState(() {
                  listAll[currentAgeGroup] = null;
                });
              },
              load: (){
                getLeaderBoard(currentAgeGroup);
              },
              callBack: (s) {
                setState(() {
                  currentAgeGroup = s;
                });
                getLeaderBoard(s);
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> getLeaderBoard(String ageGroup) async {
    ageGroup = ageGroup.split("'").length == 1
        ? ageGroup.split("'")[0]
        : ageGroup.split("'")[1];

    currentAgeGroup = ageGroup;
    if (listAll.containsKey(ageGroup)) {
      listAll[ageGroup] = null;
    }
    setState(() {});
    var res = await AvgGameController(MashovUtilities.loginData!.data)
        .getLeaderBoard(ageGroup);
    listAll[ageGroup] = List<Map<String, dynamic>>.from(res["leaderboard"]);
    setState(() {});
  }

  Widget swipeDetector(Widget child) => Column(
        children: [
          const Spacer(
            flex: 9,
          ),
          Expanded(
            flex: 15,
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                int sensitivity = 6;

                if (details.delta.dx > sensitivity) {
                  _headerKey
                      .currentState!.keySelection.currentState!.pageController
                      .nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                } else if (details.delta.dx < -sensitivity) {
                  _headerKey
                      .currentState!.keySelection.currentState!.pageController
                      .previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.ease);
                }
              },
              child: child,
            ),
          ),
        ],
      );

  Widget loading() => Container(
        width: 500,
        height: 500,
        color: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            color: SharedPreferencesUtilities.themes.colorAppBar,
          ),
        ),
      );
}
