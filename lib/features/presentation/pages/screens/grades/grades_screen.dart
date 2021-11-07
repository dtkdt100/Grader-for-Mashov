import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/grades/grade_chart_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/custom_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/calculate_avg_dialog.dart';
import '../../../widgets/pickers/fab_circular_menu/custom_fab_circular_menu.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/body_grades_design.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/utilities/sort/grades/grades_sort_by_each_grade_sort_utilities.dart';
import 'package:grader_for_mashov_new/utilities/sort/grades/grades_sort_utilities.dart';
import 'package:grader_for_mashov_new/utilities/sort/grades/grades_sorted_by_subject_sort_utilities.dart';
import '../../base_screen.dart';

class GradesScreen extends StatefulWidget {
  final int indexPage;
  const GradesScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _GradesScreenState createState() => _GradesScreenState();
}

class _GradesScreenState extends BaseScreen<GradesScreen> {
  String avg = '0';
  List<Grade>? grades;
  List<List<Grade>>? gradesBySubject;
  List<String>? findIndex;
  List<Map<String, String>>? avgGradesBySubject; // ['subject', 'avg grade'], [...]
  List<Map<String, int>>? avgTestsForEachGrade;

  int page = 0;

  @override
  String get title => 'ציונים';

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;

  @override
  int get from => widget.indexPage;

  @override
  Widget? get floatingActionButton => CustomFabCircularMenu(
    items: page == 0 ? itemsForAll() : page == 1 ? itemsForSortSubject() :
    itemsForSortEachGrade(),
  );

  List<CustomFabItem> itemsForAll() => [
    CustomFabItem(
        iconData: MdiIcons.trophy,
        onTap: () {
          GradesSortUtilities(grades!).sortByGrade();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: Icons.access_alarm,
        onTap: (){
          GradesSortUtilities(grades!).sortByDate();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: Icons.group,
        onTap: (){
          GradesSortUtilities(grades!).sortBySubject();
          setState(() {});
        }
    ),
  ];

  List<CustomFabItem> itemsForSortSubject() => [
    CustomFabItem(
        iconData: MdiIcons.sortAlphabeticalAscendingVariant,
        onTap: () {
          GradesSortedBySubjectSortUtilities(avgGradesBySubject!).sortByAlphaBet();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: MdiIcons.trophy,
        onTap: (){
          GradesSortedBySubjectSortUtilities(avgGradesBySubject!).sortByGrade();
          setState(() {});
        }
    ),
  ];

  List<CustomFabItem> itemsForSortEachGrade() => [
    CustomFabItem(
        iconData: MdiIcons.sortNumericAscendingVariant,
        onTap: () {
          GradesSortByEachGradeSortUtilities(avgTestsForEachGrade!).sortByTests();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: MdiIcons.trophy,
        onTap: (){
          GradesSortByEachGradeSortUtilities(avgTestsForEachGrade!).sortByGrade();
          setState(() {});
        }
    ),
  ];


  @override
  List<String> get threeDotsLabels {
    super.threeDotsLabels = ['רענן', 'הכל', 'לפי מקצוע ', 'לפי ציון ', 'אפשריות'];
    return super.threeDotsLabels;
  }

  @override
  Widget? get flexibleSpace => FlexibleSpaceAppBar(
    items: [
      FlexibleSpaceAppBarItem(
        description: 'מבחנים',
        mainNumber: grades == null ? '0' : grades!.length.toString(),
      ),
      FlexibleSpaceAppBarItem(
        description: 'ממוצע',
        mainNumber: avg,
      ),
    ],
  );

  @override
  Widget? get body => grades == null ? null : decideBody();

  Widget decideBody(){
    if (page == 0) {
      return BodyAllGradesDesign(
        callback: (i) {
          NavigatorUtilities(GradeChartScreen(
            gradesBySubject![findIndex!.indexOf(grades![i].subject)]
          )).pushDefault(context);
        },
        grades: grades ?? [],
      );
    } else if (page == 1) {
      return BodySubjectGradesDesign(
        gradesSubjects: gradesBySubject!,
        avgGradesBySubject: avgGradesBySubject!,
        callback: (i){
          NavigatorUtilities(GradeChartScreen(
              gradesBySubject![findIndex!.indexOf(avgGradesBySubject![i]['subject']!)]
          )).pushDefault(context);
        },
      );
    } else {
      return BodyScoresGradesDesign(
        avgTestsForEachGrade: avgTestsForEachGrade!,
      );
    }
  }

  @override
  Future<void> getMashovData() async {
    var result = await MashovUtilities.getGrades();
    setState(() {
      avg = result['avg'];
      grades = result['grades'];
      avgTestsForEachGrade = result['avgTestsForEachGrade'];
      avgGradesBySubject = result['avgGradesBySubject'];
      findIndex = result['findIndex'];
      gradesBySubject = result['gradesBySubject'];
    });
  }

  @override
  void reload() {
    grades = null;
    avg = '0';
    setState(() {});
    super.reload();
  }

  @override
  void selected(int i) {
    if (i > 0 && i < 4) {
      setState(() {
        page = i-1;
      });
    } else if (i == 4) {
      CalculateAvgDialog().showWithAnimation(context, value: {
        'grades': grades!,
        'subjects': gradesBySubject!.map((e) => e.first.subject).toList(),
      });
    }
    super.selected(i);
  }
}
