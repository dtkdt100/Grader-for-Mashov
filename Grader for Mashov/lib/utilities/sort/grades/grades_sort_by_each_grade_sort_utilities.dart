class GradesSortByEachGradeSortUtilities {
  final List<Map<String, int>> avgTestsForEachGrade;

  GradesSortByEachGradeSortUtilities(this.avgTestsForEachGrade);

  void sortByGrade() => avgTestsForEachGrade.sort((a, b) => b['grade']!.compareTo(a['grade']!));

  void sortByTests() => avgTestsForEachGrade.sort((a, b) => b['tests']!.compareTo(a['tests']!));
}