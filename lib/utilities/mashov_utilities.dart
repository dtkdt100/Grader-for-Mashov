import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/data/analyzer/analyzer.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:http/http.dart' as http;
import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:path_provider/path_provider.dart';

export 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';

class MashovUtilities {
  static final ApiController _controller = MashovApi.getController()!;

  static Login? loginData;
  static HomePageData homePageData = HomePageData.clearHomePageData;

  static Future<bool> login(LoginDetails loginDetails) async {
    Login? result = await _controller.login(loginDetails.school!,
        loginDetails.username!, loginDetails.password!, loginDetails.year!,
        uniqueId: loginDetails.uniqueId);

    loginData = result;
    return result != null;
  }

  static Future<bool> sendCode(LoginDetails loginDetails) async {
    return await _controller.sendLoginCode(
        loginDetails.school!, loginDetails.username!, loginDetails.password!);
    //return result != null;
  }

  static Future<File> getPicture() async {
    File file = await _urlToFile(
        'https://upload.wikimedia.org/wikipedia/commons/1/17/Google-flutter-logo.png');
    file = await _controller.getPicture(loginData!.students[0].id, file);
    return file;
  }

  static Future<HomePageData?> getHomePageData(VoidCallback callback) async {
    var grades = await getGrades(max: 7);
    homePageData.avg = grades['avg'];
    homePageData.grades = grades['grades'];
    callback();

    int msgCount = (await _controller.getMessagesCount()).value!.newMessages;
    homePageData.msgs = msgCount.toString();
    callback();

    var homeWork = await getHomeWork(max: 7);
    homePageData.homeWorks = homeWork!;
    callback();

    List<Lesson> day = (await getTableTime(single: true))[0];
    homePageData.hoursOfDay = day.length.toString();
    homePageData.tableTime = day;
    callback();

    homePageData.infoPlayer = await AvgGameController(MashovUtilities.loginData!.data).getInfo();
    callback();

    return homePageData;
  }

  static Future<Map<String, dynamic>?> getAttachment(String messageId, String fileId, String name) async {
    return await _controller.getAttachment(messageId, fileId, name);
  }

  static Future<Map<String, dynamic>> getGrades({int? max}) async {
    var result = await _controller.getGrades(_getUserId());
    String avg = '';
    if (SharedPreferencesUtilities.removeZeros) {
      result.value!.removeWhere((element) => element.grade == 0);
    }
    if (result.isSuccess) {
      result.value!.sort((a, b) => b.eventDate.compareTo(a.eventDate));
      avg = calculateAvg(result.value);
      if (max != null && result.value!.length > max) {
        result.value = result.value!.sublist(0, max);
      }
    }

    Map<String, dynamic> map = {
      'grades': result.value,
      'avg': avg,
    };

    if (max == null) {
      map.addAll(Analyzer<Grade>(result.value!).analyzeGrades());
    }

    return map;
  }

  static Future<List<Homework>?> getHomeWork({int? max}) async {
    var result = await _controller.getHomework(_getUserId());

    if (result.isSuccess) {
      result.value!.sort((a, b) => b.date.compareTo(a.date));

      if (max != null && result.value!.length > max) {
        result.value = result.value!.sublist(0, max);
      }
    }

    return result.value;
  }

  static Future<List<List<Lesson>>> getTableTime({bool? single}) async {
    var hour = await _controller.getTimeTable(_getUserId());
    if (single == null) return hour.value!;

    print(hour.value!.length);
    List<Lesson> singleDay = hour.value![5 - convertDateToDay()];
    return [singleDay];
  }

  static Future<Map<String, dynamic>> getBehaves() async {
    List<BehaveEvent> events =
        (await _controller.getBehaveEvents(_getUserId()))!.value!;
    int yesEvents = 0;
    int noEvents = 0;
    for (int i = 0; i < events.length; i++) {
      if (events[i].justificationId > -1) {
        yesEvents += 1;
      } else {
        noEvents += 1;
      }
    }
    events.sort((a, b) => b.date.compareTo(a.date));

    Map<String, dynamic> map = {
      'events': events,
      'yesEvents': yesEvents,
      'noEvents': noEvents,
    };
    map.addAll(Analyzer(events).analyzeBehavior());
    return map;
  }

  static Future<List<Hatama>> getHatamot() async =>
      (await _controller.getHatamot(_getUserId())).value!;

  static Future<Map<String, dynamic>> getBehavesCount() async {
    var hours = await _controller.getEventsCounter(_getUserId());
    int weeklyHours = 0;
    int totalHours = 0;

    for (int i = 0; i < hours.length; i++) {
      weeklyHours += hours[i].weeklyHours;
      totalHours += hours[i].lessonsCount;
    }

    return {
      'hours': hours,
      'weeklyHours': weeklyHours,
      'totalHours': totalHours,
    };
  }

  static Future<void> logOut() async => await _controller.logout();

  static Future<File> _urlToFile(String imageUrl) async {
    var rng = Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  static Future<Map<String, dynamic>> getMessages(int count) async {
    var msgs = await _controller.getMessages(count * 20);
    var msgCount = await _controller.getMessagesCount();
    int something = msgCount.value!.allMessages % 20;

    return {
      'msgs': msgs.value!,
      'lengthOfPages': msgCount.value!.allMessages ~/ 20 +
          (something != 0 ? 1 : 0).toDouble(),
      'readMsgs': msgCount.value!.allMessages - msgCount.value!.newMessages,
      'newMsgs': msgCount.value!.newMessages,
    };
  }

  static Future<Message> getMsg(String id) async {
    return (await _controller.getMessage(id)).value!;
  }

  static String _getUserId() => loginData!.students.first.id;

  static String calculateAvg(List<Grade>? grades,
      {List<String> avoidSub = const [], int fixed = 1}) {
    if (grades == null || grades.isEmpty) return 'אין נתונים';

    int length = grades.length;
    int total = 0;

    for (int i = 0; i < grades.length; i++) {
      if (!avoidSub.contains(grades[i].subject)) {
        if (SharedPreferencesUtilities.removeZeros) {
          if (grades[i].grade != 0) {
            total += grades[i].grade;
          } else {
            length--;
          }
        } else {
          total += grades[i].grade;
        }
      } else {
        length--;
      }
    }
    // if ((total/length).toStringAsFixed(1) == 'NaN'){
    //   return 'אין נתונים';
    // }
    return (total / length).toStringAsFixed(fixed);
  }

  static int convertDateToDay() {
    switch (DateTime.now().weekday) {
      case (DateTime.sunday):
        return 0;
      case (DateTime.monday):
        return 1;
      case (DateTime.tuesday):
        return 2;
      case (DateTime.wednesday):
        return 3;
      case (DateTime.thursday):
        return 4;
      case (DateTime.friday):
        return 5;
      case (DateTime.saturday):
        return 6;
    }
    return -1;
  }
}
