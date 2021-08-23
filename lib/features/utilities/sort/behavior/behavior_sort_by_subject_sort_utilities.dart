class GradesSortedBySubjectSortUtilities {
  final List<Map<String, dynamic>> behavesForSubjects;

  GradesSortedBySubjectSortUtilities(this.behavesForSubjects);

  void sortByEvents() => behavesForSubjects.sort((a, b) => b['all']!.compareTo(a['all']!));

  void sortByAlphaBet() => behavesForSubjects.sort((a, b) => a['value']!.compareTo(b['value']!));
}