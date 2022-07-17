import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';

class HomePageData {
  String avg;
  String hoursOfDay;
  String msgs;

  List<Homework>? homeWorks;
  List<Grade>? grades;
  List<Lesson>? tableTime;

  Map<String, dynamic>? infoPlayer;

  HomePageData({
    required this.msgs,
    required this.grades,
    required this.avg,
    required this.homeWorks,
    required this.hoursOfDay,
    required this.tableTime,
    required this.infoPlayer,
  });

  void clear() {
    avg = '0';
    grades = null;
    hoursOfDay = '0';
    msgs = '0';
    tableTime = null;
    homeWorks = null;
    infoPlayer = null;
  }

  static HomePageData clearHomePageData = HomePageData(
      avg: '0',
      grades: null,
      hoursOfDay: '0',
      msgs: '0',
      tableTime: null,
      homeWorks: null,
      infoPlayer: null);
}
