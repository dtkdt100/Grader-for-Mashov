import '../../utils.dart';

class Lesson {
  int groupId, day, lesson;
  String subject, room, startTime, endTime;
  List<String> teachers;

  Lesson(
      {required this.groupId,
        required this.day,
        required this.lesson,
        required this.startTime,
        required this.endTime,
        required this.subject,
        required this.teachers,
        required this.room,});

  static Lesson fromJson(Map<dynamic, dynamic> src) {
    var tableData = src["timeTable"];
    var details = src["groupDetails"];
    bool tableDataNull = tableData == null;
    bool detailsNull = details == null;
    return Lesson(
        groupId: Utils.integer(tableDataNull ? null : tableData["groupId"]),
        day: Utils.integer(tableDataNull ? null : tableData["day"]),
        lesson: Utils.integer(tableDataNull ? null : tableData["lesson"]),
        startTime: Utils.string(src["startTime"]),
        endTime: Utils.string(src["endTime"]),
        subject: Utils.string(detailsNull ? null : details["subjectName"]),
        teachers: detailsNull
            ? null
            : details["groupTeachers"]
            .map<String>((t) => "${t["teacherName"]}")
            .toList(),
        room: Utils.string(tableDataNull ? null : tableData["roomNum"]));
  }

  @override
  String toString() =>
      super.toString() +
          " => { $groupId, $day, $lesson,$startTime-$endTime,$subject, ${teachers
              .join(", ")}, $room }";
}
