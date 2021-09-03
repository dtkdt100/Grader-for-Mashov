import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/homework/homework_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/leader_board/screens/leader_board_first_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/messages/messages_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_order_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/show_player_info.dart';
import '../../widgets/custom_dialog/dialogs/home_page_dialogs/change_avg_zeros_dialog.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'grades/grades_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/table_time_screen.dart';
import '../../widgets/custom_dialog/dialogs/home_page_dialogs/change_theme_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_grade.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_homework.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_lesson.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/card_design.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/navigator_utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseScreen<HomePage> {
  Widget nothingWidget = const SizedBox();

  List<FlexibleSpaceAppBarItem> items = [
    FlexibleSpaceAppBarItem(
      mainNumber: '0',
      description: 'הודעות',
      color: Colors.green,
    ),
    FlexibleSpaceAppBarItem(
      mainNumber: '0',
      description: 'ממוצע',
      color: Colors.yellow,
    ),
    FlexibleSpaceAppBarItem(
      mainNumber: '0',
      description: 'שעות היום',
      color: Colors.red,
    ),
  ];

  @override
  void initState() {
    items[2].callback = () {
      _topHeaderCallBack(const TableTimeScreen(2));
    };
    items[1].callback = () {
      _topHeaderCallBack(const GradesScreen(1));
    };
    items[0].callback = () {
      _topHeaderCallBack(const MessagesScreen(5));
    };
    super.initState();
  }

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;

  @override
  String get title => 'מסך הבית';

  @override
  int get from => 0;

  @override
  List<String> get threeDotsLabels {
    super.threeDotsLabels = ['רענן', 'שנה סידור', 'שנה ערכת צבע', 'הסרת הערות'];
    return super.threeDotsLabels;
  }

  @override
  Widget? get adWidget => adForLeaderBoard();

  @override
  Widget get body {
    HomePageData homePageData = MashovUtilities.homePageData;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
      child: Column(
        children: [
          SharedPreferencesUtilities.homePageCards![0]
              ? CardDesign(
                  callback: () {
                    NavigatorUtilities(const GradesScreen(1))
                        .pushDefault(context);
                  },
                  title: 'ציונים אחרונים',
                  child: homePageData.grades == null
                      ? null
                      : homePageData.grades!.isEmpty
                          ? noData()
                          : Column(
                              children: List.generate(
                                  homePageData.grades!.length, (index) {
                                return OneLineGrade(
                                  grade: homePageData.grades![index],
                                  pad1: 0,
                                  pad2: 0,
                                  pad3: 3,
                                );
                              }),
                            ),
                )
              : nothingWidget,
          SharedPreferencesUtilities.homePageCards![1]
              ? CardDesign(
                  callback: () {
                    NavigatorUtilities(const HomeworkScreen(4))
                        .pushDefault(context);
                  },
                  title: 'שיעורי בית',
                  child: homePageData.homeWorks == null
                      ? null
                      : homePageData.homeWorks!.isEmpty
                          ? noData()
                          : Column(
                              children: List.generate(
                                  homePageData.homeWorks!.length, (index) {
                                return OneLineHomework(
                                  homework: homePageData.homeWorks![index],
                                  index: index,
                                  pad: 1.0,
                                  font1: 15.0,
                                  cutLine: true,
                                );
                              }),
                            ),
                )
              : nothingWidget,
          SharedPreferencesUtilities.homePageCards![2]
              ? CardDesign(
                  callback: () {
                    NavigatorUtilities(const TableTimeScreen(2))
                        .pushDefault(context);
                  },
                  title: 'מערכת שעות יומית',
                  removeBottom:
                      !SharedPreferencesUtilities.connectedToLeaderBoard,
                  child: homePageData.tableTime == null
                      ? null
                      : homePageData.tableTime!.isEmpty
                          ? noData()
                          : Column(
                              children: List.generate(
                                  homePageData.tableTime!.length, (index) {
                                return OneLineLesson(
                                  lesson: homePageData.tableTime![index],
                                  glow: false,
                                  pad1: 2,
                                  pad2: 7,
                                  font1: 16,
                                  font2: 17,
                                );
                              }),
                            ),
                )
              : nothingWidget,
          SharedPreferencesUtilities.connectedToLeaderBoard
              ? SharedPreferencesUtilities.homePageCards![3]
                  ? CardDesign(
                      title: 'תחרות ממוצע ציונים',
                      callback: () {
                        NavigatorUtilities.navigateToLeaderBoardScreen(context);
                      },
                      child: homePageData.infoPlayer == null
                          ? null
                          : ShowPlayerInfo(homePageData.infoPlayer!),
                      removeBottom: true,
                    )
                  : nothingWidget
              : nothingWidget,
        ],
      ),
    );
  }

  Widget adForLeaderBoard() => SharedPreferencesUtilities.connectedToLeaderBoard
      ? const SizedBox()
      : Container(
          width: double.infinity,
          color: Colors.grey.withOpacity(0.8),
          child: Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              const Text("חדש! תחרות ממוצע ציונים"),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  await NavigatorUtilities(const LeaderBoardFirstScreen())
                      .pushDefault(context);
                  setState(() {});
                },
                child: const Text("הירשם"),
              ),
              const SizedBox(
                width: 5,
              ),
            ],
          ),
        );

  Widget noData() => Row(
        children: const [
          Spacer(),
          Text('אין נתונים'),
          Spacer(),
        ],
      );

  @override
  Widget? get flexibleSpace => FlexibleSpaceAppBar(items: items);

  @override
  Future<void> getMashovData() async {
    await MashovUtilities.getHomePageData(() {
      reloadHeader();
    });
    if (SharedPreferencesUtilities.connectedToLeaderBoard) updateAvg();
  }

  Future<void> updateAvg() async {
    double avg;
    try {
      avg = double.parse(MashovUtilities.homePageData.avg);
      if (MashovUtilities.loginData!.students[0].classCode != null) {
        AvgGameController(MashovUtilities.loginData!.data)
            .updateAvg(avg, MashovUtilities.loginData!);
      }
    } catch (e) {
      debugPrint('');
    }
  }

  @override
  void selected(int i) async {
    switch (i) {
      case 1:
        await ChangeOrderDialog().showWithAnimation(context);
        setState(() {});
        break;
      case 2:
        await ChangeThemeDialog().showWithAnimation(context);
        setState(() {});
        break;
      case 3:
        await ChangeAvgZerosDialog().showWithAnimation(context);
        getMashovData();
        setState(() {});
        break;
    }
    super.selected(i);
  }

  @override
  void reload() {
    MashovUtilities.homePageData = HomePageData(
        avg: '0',
        grades: null,
        hoursOfDay: '0',
        msgs: '0',
        tableTime: null,
        homeWorks: null,
        infoPlayer: null);
    reloadHeader();
    super.reload();
  }

  void reloadHeader() {
    setState(() {
      items[2].mainNumber = MashovUtilities.homePageData.hoursOfDay;
      items[1].mainNumber = MashovUtilities.homePageData.avg;
      items[0].mainNumber = MashovUtilities.homePageData.msgs;
    });
  }

  void _topHeaderCallBack(Widget destination) =>
      NavigatorUtilities(destination).pushDefault(context);
}
