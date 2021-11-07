import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/homework.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/homework/homework_big_screen.dart';
import 'package:grader_for_mashov_new/utilities/navigator_utilities.dart';

class OneLineHomework extends StatelessWidget {
  final Homework homework;
  final int index;
  final bool cutLine;
  final double font1;
  final double pad;

  const OneLineHomework({Key? key,
    required this.homework,
    required this.index,
    this.cutLine = false,
    this.font1 = 17.0,
    this.pad = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String msg = homework.message;
    if (cutLine){
      msg = homework.message.replaceAll("\n", " ");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onTap: cutLine ? null : () {
            NavigatorUtilities(HomeworkBigScreen(homework: homework, index: index)).pushDefault(context);
          },
          child: Padding(
            padding: EdgeInsets.all(pad),
            child: Hero(
              tag: cutLine ? "homePage$index" : index,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          homework.subject,
                          style: TextStyle(
                              fontSize: font1,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '${homework.date.day}/${homework.date.month}/${homework.date.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: cutLine ? 60 : 0),
                    child: Text(
                      msg,
                      maxLines: cutLine ? 1 : 10,
                      style: TextStyle(
                          fontWeight: cutLine ? FontWeight.normal : FontWeight.w500,
                          color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ),
        cutLine ? const SizedBox() : const Divider(
          height: 0,
        ),
      ],
    );
  }
}