import '../../utils.dart';

class BehaveEvent {
  int groupId, lesson, type, justificationId;
  String text, justification, reporter, subject;
  DateTime date;

  BehaveEvent(
      {required this.groupId,
        required this.lesson,
        required this.date,
        required this.type,
        required this.text,
        required this.justificationId,
        required this.justification,
        required this.reporter,
        required this.subject});

  static BehaveEvent fromJson(Map<String, dynamic> src) => BehaveEvent(
      groupId: Utils.integer(src["groupId"]),
      lesson: Utils.integer(src["lesson"]),
      date: DateTime.parse(src["lessonDate"]),
      type: Utils.integer(src["lessonType"]),
      text: Utils.string(src["achvaName"]),
      justificationId: Utils.integer(src["justificationId"]),
      justification: Utils.string(src["justification"]),
      reporter: Utils.string(src["reporter"]),
      subject: Utils.string(src["subject"]));

  @override
  String toString() {
    return super.toString() +
        " => {$groupId, $lesson, ${date.toIso8601String()}, $type, $text, $justificationId, $justification, $reporter, $subject";
  }
}