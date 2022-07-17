import '../../utils.dart';

class Bagrut {
  String semel, name, moed, date, room, examStartTime, examEndTime;
  int finalGrade, yearGrade, testGrade;

  Bagrut(
      {required this.semel,
        required this.name,
        required this.date,
        required this.moed,
        required this.examStartTime,
        required this.examEndTime,
        required this.room,
        required this.finalGrade,
        required this.yearGrade,
        required this.testGrade});

  String stringify() => """{
  semel:      $semel,
  name:       $name,
  date:       $date,
  moed:       $moed,
  room:       $room,
  finalGrade: $finalGrade,
  yearGrade:  $yearGrade,
  testGrade:  $testGrade,
  times:      $examStartTime-$examEndTime,

  }""";

  static Bagrut fromJson(Map<dynamic, dynamic> src) =>
      Bagrut(
          semel: Utils.string(src["semel"]),
          name: Utils.string(src["name"]),
          date: Utils.string(src["examDate"]),
          moed: Utils.string(src["moed"]),
          room: Utils.string(src["examRoomNumber"]),
          examStartTime: Utils.string(src["examStartTime"]),
          examEndTime: Utils.string(src["examEndTime"]),
          finalGrade: Utils.integer(src["final"]),
          yearGrade: Utils.integer(src["shnaty"]),
          testGrade: Utils.integer(src["test"]));
}