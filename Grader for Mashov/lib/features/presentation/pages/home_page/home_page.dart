import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/second_pages/grades/grades_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/second_pages/homework/homework_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/second_pages/leader_board/screens/leader_board_first_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/second_pages/messages/messages_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_avg_zeros_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_order_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_theme_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/leader_board_widgets/show_player_info.dart';
import '../../../../main.dart';
import '../second_pages/table_time_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_grade.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_homework.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_lesson.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/card_design.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/utilities/app/navigator_utilities.dart';
import 'package:grader_for_mashov_new/utilities/cloud/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/phone/shared_preferences_utilities.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseScreen<HomePage> with WidgetsBindingObserver {
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
  void dispose() {
    //AdsUtilities.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    // AdsUtilities.loadShowNativeAd(() {
    //   setState(() {});
    // });

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
  void didChangePlatformBrightness() {
    //if (MyApp.navigatorKey.currentState!.mounted) {
      ThemeUtilities.changeBrightness(WidgetsBinding.instance.window.platformBrightness);

      setState(() {

      });

      MyApp.navigatorKey.currentState!.setState(() {

      });
   // }

    super.didChangePlatformBrightness();
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
                  removeBottom: false,
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
          //AdsUtilities.nativeAdWidget(),
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
      if (MashovUtilities.loginData!.students[0].classCode != null &&
          avg != SharedPreferencesUtilities.lastAvg) {
        AvgGameController(MashovUtilities.loginData!.data)
            .updateAvg(avg, MashovUtilities.loginData!);
        SharedPreferencesUtilities.setLastAvg(avg);
      }
    } catch (e) {
      debugPrint('');
    }
  }

  @override
  void selected(int i) {
    switch (i) {
      case 1:
        ChangeOrderDialog().showWithAnimation(context).then((value) => value == true ? setState(() {}) : null);
        break;
      case 2:
        ChangeThemeDialog().showWithAnimation(context).then((value) => value == true ? setState(() {}) : null);
        break;
      case 3:
        ChangeAvgZerosDialog()
            .showWithAnimation(context,
                value: InfoForChange('הסרת הערות:',
                    'האם ברצונך לחשב ממוצע ללא הערות? \n (הערות מופיעות בGrader כ0)'))
            .then((value) {
          if (value != null) {
            SharedPreferencesUtilities.setZero(value == true);
            MashovUtilities.homePageData.clear();
            getMashovData();
            setState(() {});
          }
        });
        break;
    }
    super.selected(i);
  }

  @override
  void reload() {
    MashovUtilities.homePageData.clear();
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
