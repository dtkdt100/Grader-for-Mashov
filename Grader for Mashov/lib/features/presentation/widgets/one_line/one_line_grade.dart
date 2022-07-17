import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/grade.dart';
import '../../../../utilities/phone/shared_preferences_utilities.dart';

class OneLineGrade extends StatelessWidget {
  final Grade grade;
  final double pad1, pad2, pad3;

  const OneLineGrade({Key? key,
    required this.grade,
    this.pad1 = 15,
    this.pad2 = 7,
    this.pad3 = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(right: pad3, top: pad3, bottom: pad3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(grade.event, style: const TextStyle(fontSize: 16),
                  overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2,),
                Text(grade.subject, style: TextStyle(fontSize: 14, color: Colors.grey[500]),),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: pad1, top: pad2,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              _getGradeDesign(grade.grade),
              const SizedBox(height: 3,),
              Text('${grade.eventDate.day}.${grade.eventDate.month}.${grade.eventDate.year}',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500])),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _getGradeDesign(int grade) {
    Color color = Colors.red;
    if (grade >= 90){
      color = Colors.green;
    }
    else if (grade >= 70){
      color = Colors.blue;
    }
    return Container(
      height: 20,
      width: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(ThemeUtilities.themes.opacity),
        borderRadius: const BorderRadius.all(Radius.elliptical(110,70)),
      ),
      child: Center(child: Text('$grade', style: const TextStyle(color: Colors.white),)),
    );
  }

}
