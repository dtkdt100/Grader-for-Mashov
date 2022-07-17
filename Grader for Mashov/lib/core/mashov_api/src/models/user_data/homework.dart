import '../../utils.dart';

class Homework {
  String message, subject;
  DateTime date;

  Homework({required this.message, required this.subject, required this.date});

  static Homework fromJson(Map<String, dynamic> src) => Homework(
      message: Utils.string(src["homework"]),
      date: DateTime.parse(src["lessonDate"]),
      subject: Utils.string(src["subjectName"]));
}