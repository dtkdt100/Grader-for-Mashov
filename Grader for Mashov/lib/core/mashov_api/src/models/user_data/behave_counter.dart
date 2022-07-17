import 'short_behave_event.dart';

class BehaveCounter {
  String subject;
  int lessonsCount, weeklyHours, totalEvents;
  List<ShortBehaveEvent> events;

  BehaveCounter({
    required this.totalEvents,
    required this.subject,
    required this.weeklyHours,
    required this.lessonsCount,
    required this.events
  });
}