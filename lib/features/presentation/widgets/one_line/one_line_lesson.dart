import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/lesson.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

class OneLineLesson extends StatelessWidget {
  final Lesson lesson;
  final bool glow;

  final double pad1, pad2;
  final double font1, font2;

  const OneLineLesson({Key? key,
    required this.lesson,
    this.glow = false,
    this.pad1 = 8.0,
    this.pad2 = 12.0,
    this.font1 = 20.0,
    this.font2 = 18.0,
    //this.font3 = ,
  }) : super(key: key);

  final String free = "שיעור חופשי!";

  @override
  Widget build(BuildContext context) {

    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: glow ? SharedPreferencesUtilities.themes.colorAppBar.withOpacity(0.4) : Colors.transparent,
      ),
      padding: EdgeInsets.fromLTRB(pad1, lesson.subject == free ? pad2 : pad1, pad1 == 2.0 ? pad1+1 : pad1,
          lesson.subject == free ? pad2 :  pad1 == 2.0 ? pad1+1 : pad1),
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                  // child: Center(child: Text('${counter+lessonFree}', style: TextStyle(color: Colors.white),)),
                  child: Center(
                      child: Text(
                        '${lesson.lesson}',
                        style: const TextStyle(color: Colors.white),
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        lesson.subject,
                        style: TextStyle(
                            fontSize: lesson.subject == free ? font1 : font2,
                            color: lesson.subject == free
                                ? Colors.blue
                                : Colors.black),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                      lesson.subject == free
                          ? const SizedBox()
                          : Text(
                        lesson.teachers[0],
                        style: TextStyle(
                            fontSize: pad1 == 2.0 ? 14 : 15, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          pad1 == 2.0 ? const SizedBox() : Text(
            _timeStartAndEnd(lesson),
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  static String _timeStartAndEnd(Lesson lesson) {
    String start = lesson.startTime.substring(0, 5);
    String end = lesson.endTime.substring(0, 5);
    return '($end - $start)';
  }
}