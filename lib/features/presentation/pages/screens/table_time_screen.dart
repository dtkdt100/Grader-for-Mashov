import 'dart:async';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_lesson.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pickers/three_dots_picker.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

class TableTimeScreen extends StatefulWidget {
  final int indexPage;
  const TableTimeScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _TableTimeScreenState createState() => _TableTimeScreenState();
}

class _TableTimeScreenState extends BaseScreen<TableTimeScreen> {
  List<List<Lesson>>? lessons;
  List<String> days = ['ראשון', 'שני', 'שלישי', 'רביעי', 'חמישי', 'שישי'];
  List<List<bool>?> currentHour = [];

  @override
  int get from => widget.indexPage;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: DefaultTabController(
        length: 6,
        initialIndex: MashovUtilities.convertDateToDay() == 6 ? 5 : MashovUtilities.convertDateToDay(),
        child: Scaffold(
          drawer: const GraderDrawer(2),
          appBar: AppBar(
            backgroundColor: SharedPreferencesUtilities.themes.colorAppBar,
            actions: [ThreeDotsPicker(
              children: const ['רענן'],
              selected: (i){
                reload();
              },
            )],
            title: const Text('מערכת שעות'),
            bottom: TabBar(
                indicatorColor: Colors.yellow,
                labelPadding: const EdgeInsets.all(0),
                tabs: List.generate(6, (index) {
                  return Tab(
                    child: Text(days[index]),
                  );
                })),
          ),
          body: TabBarView(
              children: List.generate(6, (index2) {
                if (lessons == null) {
                  return const Center(
                    child: CircularProgressIndicator()
                  );
                }
                return ListView(
                  children: List.generate(lessons![5-index2].length, (index) {
                    return OneLineLesson(
                      lesson: lessons![5-index2][index],
                      glow: currentHour[5-index2] == null ? false : currentHour[5-index2]![index],
                    );
                  }),
                );
              })),
        ),
      ),
    );
  }

  @override
  String get title => 'מערכת שעות';


  @override
  Future<void> getMashovData() async {
    lessons = await MashovUtilities.getTableTime();
    setState(() {});

    for (int i = 0; i < lessons!.length; i++) {
      currentHour.add([]);
      for (int j = 0; j < lessons![i].length; j++) {
        currentHour[i]!.add(false);
      }
    }

    findCurrentHour();
  }

  void findCurrentHour() {
    DateTime now = DateTime.now();
    //now = DateTime.parse("2021-09-04 12:46:00");
    List<Lesson> lessonsDay = [];
    int day = now.weekday;
    int? lesson;

    if (now.weekday == 6) {
      lessonsDay = [];
      day = -1;
    } else if (now.weekday == 7) {
      lessonsDay = lessons![5];
      day = 5;
    } else {
      lessonsDay = lessons![5 - now.weekday];
      day = 5 - now.weekday;
    }

    if (lessonsDay.isNotEmpty) {
      for (int i = 0; i < lessonsDay.length; i++) {
        String years =
            '${now.year}-${_correctHours(now.month)}-${_correctHours(now.day)}';
        DateTime start = DateTime.parse("$years ${lessonsDay[i].startTime}");
        DateTime end = DateTime.parse("$years ${lessonsDay[i].endTime}");
        if (now.difference(start).inMinutes >= 0 &&
            now.difference(end).inMinutes <= 0) {
          lesson = i;
        }
      }
      if (lesson != null) {
        Timer(const Duration(milliseconds: 250), () {
          setState(() {
            currentHour[day]![lesson!] = true;
          });
          Timer(const Duration(milliseconds: 10000), () {
            setState(() {
              currentHour[day]![lesson!] = false;
            });
          });
        });
      }
    }
  }

  String _correctHours(int fix) {
    if (fix.toString().length == 1) {
      return '0$fix';
    }
    return '$fix';
  }

  @override
  void reload() {
    lessons = null;
    setState(() {});
    getMashovData();
  }

}
