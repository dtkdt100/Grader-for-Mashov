import '../../utils.dart';

class Grade {
  String teacher, subject, event, gradeType;
  DateTime eventDate;
  int groupId, type, grade;

  Grade(
      {required this.teacher,
      required this.groupId,
      required this.subject,
      required this.eventDate,
      required this.event,
      required this.type,
      required this.grade,
      required this.gradeType});

  static Grade fromJson(Map<String, dynamic> src) {
    return Grade(
        teacher: Utils.string(src["teacherName"]),
        groupId: Utils.integer(src["groupId"]),
        subject: Utils.string(src["subjectName"]),
        eventDate: DateTime.parse(src["eventDate"]),
        event: Utils.string(src["gradingEvent"]),
        type: Utils.integer(src["gradeTypeId"]),
        grade: Utils.integer(src["grade"]),
        gradeType: Utils.string(src["gradeType"]));
  }

  static List<Grade> fromJsonArray(List<dynamic> src) =>
      src.map((g) => fromJson(g)).toList();

  @override
  String toString() {
    return super.toString() +
        "-> { teacher: $teacher, groupId: $groupId, subject: $subject, eventDate: ${eventDate.toIso8601String()}(${eventDate.millisecondsSinceEpoch}), event: $event, type: $type, grade: $grade, gradeType: $gradeType }";
  }
}
