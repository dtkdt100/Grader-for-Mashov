import '../../utils.dart';

class LessonCount {
  int groupId, lessonsCount, weeklyHours;

  LessonCount({
    required this.groupId,
    required this.lessonsCount,
    required this.weeklyHours
  });

  static LessonCount fromJson(Map<String, dynamic> src) => LessonCount(
    groupId: Utils.integer(src["groupId"]),
    lessonsCount: Utils.integer(src["lessonsCount"]),
    weeklyHours: Utils.integer(src["weeklyHours"]),
  );

  @override
  String toString() {
    return super.toString() +
        " => {$groupId, $lessonsCount, $weeklyHours";
  }
}