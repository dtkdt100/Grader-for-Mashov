import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/grade.dart';

class GradesSortUtilities {
  final List<Grade> grades;

  GradesSortUtilities(this.grades);

  void sortByGrade() => grades.sort((a, b) {
    if (a.grade == b.grade) {
      return b.eventDate.compareTo(a.eventDate);
    }
    return b.grade.compareTo(a.grade);
  });

  void sortBySubject() => grades.sort((a, b){
    if (a.subject == b.subject){
      return b.eventDate.compareTo(a.eventDate);
    }
    return a.subject.compareTo(b.subject);
  });

  void sortByDate() => grades.sort((a, b) => b.eventDate.compareTo(a.eventDate));

}