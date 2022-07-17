import '../../utils.dart';

class Group {
  int id;
  String subject;
  List<String>? teachers;

  Group({required this.id, required this.subject, this.teachers}) {
    teachers ??= [];
  }

  static Group fromJson(Map<String, dynamic> src) {
    return Group(
      id: Utils.integer(src["groupId"]),
      subject: Utils.string(src["subjectName"]).replaceAll("''", "\""),
      teachers: src["groupTeachers"]
          .map<String>((t) => "${t["teacherName"]}")
          .toList(),
    );
  }

  @override
  String toString() =>
      super.toString() +
          " => { id: $id, $subject" +
          (teachers!.isNotEmpty ? " - [${teachers!.join(", ",)}]" : "") +
          " }";

}