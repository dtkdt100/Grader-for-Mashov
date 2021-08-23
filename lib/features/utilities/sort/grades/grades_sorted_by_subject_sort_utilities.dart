class GradesSortedBySubjectSortUtilities {
  final List<Map<String, String>> gradesBySubject;

  GradesSortedBySubjectSortUtilities(this.gradesBySubject);

  void sortByGrade() => gradesBySubject.sort((a, b) => double.parse(b['avg']!).compareTo(double.parse(a['avg']!)));

  void sortByAlphaBet() => gradesBySubject.sort((a, b) => a['subject']!.compareTo(b['subject']!));
}