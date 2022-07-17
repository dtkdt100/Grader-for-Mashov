import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/grade.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_grade.dart';

class BodyAllGradesDesign extends StatelessWidget {
  final List<Grade> grades;
  final Function(int) callback;

  const BodyAllGradesDesign({
    Key? key,
    required this.callback,
    required this.grades,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grades.isEmpty
          ? <Widget>[
              const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: Text('אין נתונים')),
              )
            ]
          : List.generate(grades.length, (index) {

              return InkWell(
                onTap: () {
                  callback(index);
                },
                child: Column(
                  children: <Widget>[
                    OneLineGrade(grade: grades[index]),
                    const Divider(
                      height: 2,
                    ),
                  ],
                ),
              );
            }),
    );
  }
}

class BodySubjectGradesDesign extends StatelessWidget {
  final List<List<Grade>> gradesSubjects;
  final Function(int) callback;
  final List<Map<String, String>> avgGradesBySubject;

  const BodySubjectGradesDesign({
    Key? key,
    required this.callback,
    required this.gradesSubjects,
    required this.avgGradesBySubject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(gradesSubjects.length, (index) {
        return InkWell(
          onTap: () {
            callback(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  avgGradesBySubject[index]['subject']!,
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                      fontSize: 19),
                ),
                Text(avgGradesBySubject[index]['avg']!,
                    style: TextStyle(color: Colors.grey[600], fontSize: 19)),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class BodyScoresGradesDesign extends StatelessWidget {
  final List<Map<String, int>> avgTestsForEachGrade; // [grade, tests], [...]

  const BodyScoresGradesDesign({Key? key, required this.avgTestsForEachGrade})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(avgTestsForEachGrade.length, (index) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30, top: 8, bottom: 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'ציון',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      Text(
                        '${avgTestsForEachGrade[index]['grade']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, top: 6, bottom: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '${avgTestsForEachGrade[index]['tests']}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      Text(
                        'מבחנים',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(
              height: 2,
              thickness: 0.8,
            )
          ],
        );
      }),
    );
  }
}
