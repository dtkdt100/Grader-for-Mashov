import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/behave_event.dart';

class BehaviorSortUtilities {
  final List<BehaveEvent> grades;

  BehaviorSortUtilities(this.grades);

  void sortBySubject() => grades.sort((a, b){
    if (a.subject == b.subject){
      return b.date.compareTo(a.date);
    }
    return a.subject.compareTo(b.subject);
  });

  void sortByDate() => grades.sort((a, b) => b.date.compareTo(a.date));

}