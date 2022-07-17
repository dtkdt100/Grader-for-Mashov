
import '../../../utilities/cloud/mashov_utilities.dart';

class Analyzer<E> {
  List<E> list;

  Analyzer(this.list);

  Map<String, dynamic> analyzeGrades (){
    List<Grade> grades = List<Grade>.from(list);
    List<List<Grade>> gradesBySubject = [];
    List<String> findIndex = [];
    List<Map<String, String>> avgGradesBySubject = []; // ['subject', 'avg grade'], [...]
    List<Map<String, int>> avgTestsForEachGrade = _getAvgTestsForEachGrade(grades);

    grades.sort((a, b) {
      if (a.subject == b.subject){
        return b.eventDate.compareTo(a.eventDate);
      }
      return a.subject.compareTo(b.subject);
    });

    String subject = '';
    int counter = -1;
    for (int i = 0; i < list.length; i++) {
      if (subject != grades[i].subject) {
        subject =  grades[i].subject;
        counter += 1;
        findIndex.add(grades[i].subject);
        gradesBySubject.add([]);
      }
      gradesBySubject[counter].add(grades[i]);
    }

    for (int i = 0; i < gradesBySubject.length; i++){
      avgGradesBySubject.add(
        {
          'subject': gradesBySubject[i][0].subject,
          'avg': MashovUtilities.calculateAvg(gradesBySubject[i]),
        }
      );
    }

    return {
      'gradesBySubject': gradesBySubject,
      'findIndex': findIndex,
      'avgGradesBySubject': avgGradesBySubject,
      'avgTestsForEachGrade': avgTestsForEachGrade,
    };
  }

  static List<Map<String, int>> _getAvgTestsForEachGrade(List<Grade> grades) {
    int totalSubjects = 0;
    int grade = -1;
    List<Map<String, int>> secondList = [];
    grades.sort((a, b) => b.grade.compareTo(a.grade));

    for(int i = 0; i < grades.length; i++){
      if (grade != grades[i].grade){
        grade = grades[i].grade;
        totalSubjects+=1;
        secondList.add(
          {
            'grade': grade,
            'tests': 0,
          },
        );
      }
    }
    for (int i = 0; i < totalSubjects; i++){
      for (int j = 0; j < grades.length; j++){
        if (secondList[i].containsValue(grades[j].grade)){
          secondList[i]['tests'] = (secondList[i]['tests']! + 1);
        }
      }
    }
    return secondList;
  }

  Map<String, dynamic> analyzeBehavior() {
    List<BehaveEvent> events = List<BehaveEvent>.from(list);
    List<Map<String, dynamic>> behavesForSubjects = _getBehavesForSubjects(events);
    List<Map<String, dynamic>> behavesForEvents = _getBehavesForEvents(events);


    return {
      'behavesForSubjects': behavesForSubjects,
      'behavesForEvents': behavesForEvents,
    };
  }

  static List<Map<String, dynamic>>  _getBehavesForSubjects(List<BehaveEvent> behave) {
    int totalSubjects = 0;
    String subject = '';
    List<Map<String, dynamic>> secondList = [];
    behave.sort((a, b) => b.subject.compareTo(a.subject));

    for (int i = 0; i < behave.length; i++) {
      if (subject != behave[i].subject) {
        subject = behave[i].subject;
        totalSubjects += 1;
        secondList.add(
          {
            'value': subject,
            'yesEvents': 0,
            'noEvents': 0,
            'all': 0
          }
        );
      }
    }
    for (int i = 0; i < totalSubjects; i++) {
      for (int j = 0; j < behave.length; j++) {
        if (secondList[i].containsValue(behave[j].subject)) {
          if (behave[j].justificationId == -1) {
            secondList[i]['noEvents'] += 1;
          } else {
            secondList[i]['yesEvents'] += 1;
          }
          secondList[i]['all'] += 1;
        }
      }
    }
    return secondList;
  }

  static List<Map<String, dynamic>>  _getBehavesForEvents(List<BehaveEvent> behave) {
    int totalSubjects = 0;
    String event = '';
    List<Map<String, dynamic>> secondList = [];
    behave.sort((a, b) => b.text.compareTo(a.text));

    for (int i = 0; i < behave.length; i++) {
      if (event != behave[i].text) {
        event = behave[i].text;
        totalSubjects += 1;
        secondList.add(
          {
            'value': event,
            'yesEvents': 0,
            'noEvents': 0,
            'all': 0
          }
        );
      }
    }
    for (int i = 0; i < totalSubjects; i++) {
      for (int j = 0; j < behave.length; j++) {
        if (secondList[i].containsValue(behave[j].text)) {
          if (behave[j].justificationId == -1) {
            secondList[i]['noEvents'] += 1;
          } else {
            secondList[i]['yesEvents'] += 1;
          }
          secondList[i]['all'] += 1;
        }
      }
    }
    return secondList;
  }
}