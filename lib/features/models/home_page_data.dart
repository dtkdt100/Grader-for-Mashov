import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';

class HomePageData {
  String avg;
  String hoursOfDay;
  String msgs;

  List<Homework>? homeWorks;
  List<Grade>? grades;
  List<Lesson>? tableTime;

  HomePageData({
    required this.msgs,
    required this.grades,
    required this.avg,
    required this.homeWorks,
    required this.hoursOfDay,
    required this.tableTime,
  });

  static HomePageData clearHomePageData = HomePageData(
      avg: '0',
      grades: null,
      hoursOfDay: '0',
      msgs: '0',
      tableTime: null,
      homeWorks: null);
}