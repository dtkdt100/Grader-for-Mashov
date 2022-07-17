// ignore_for_file: constant_identifier_names

import 'dart:math';

import 'package:flutter/material.dart';
import '../../../../../utilities/cloud/mashov_utilities.dart';

const SCALE_FRACTION = 0.7;
const FULL_SCALE = 1.0;
const PAGER_HEIGHT = 130.0;


class LeaderBoardSelection extends StatefulWidget {
  final Function(String) callBack;
  const LeaderBoardSelection({Key? key, required this.callBack}) : super(key: key);

  @override
  LeaderBoardSelectionState createState() => LeaderBoardSelectionState();
}

class LeaderBoardSelectionState extends State<LeaderBoardSelection> {
  static double viewPortFraction = 0.3;
  int currentPage = 1;

  PageController pageController = PageController(initialPage: 1, viewportFraction: viewPortFraction);

  double value = 0;
  double page = 1.0;

  static List<String> options = ["כללי", "בתי ספר", "'ז", "'ח",  "'ט", "'י", 'י"א', 'י"ב'];

  @override
  void initState() {
    getStartAgeGroup();
    Future.delayed(const Duration(milliseconds: 50), (){
      widget.callBack(options[1]);
    });
    super.initState();
  }

  getStartAgeGroup() {
    if (MashovUtilities.loginData!.students[0].classCode != null) {
      int index = options.indexOf(
          "'" + MashovUtilities.loginData!.students[0].classCode!);
      if (index != -1) {
        options.insert(1, options[index]);
        options.removeAt(index + 1);
      } else {
        int index = options.indexWhere((element) {
          if (element.contains('"')) {
            element = element.replaceRange(1, 2, '');
          }
          return element.contains(MashovUtilities.loginData!.students[0].classCode!);
        });
        if (index != -1) {
          options.insert(1, options[index]);
          options.removeAt(index + 1);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: PAGER_HEIGHT,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  page = pageController.page!;
                });
              } else if (notification is ScrollEndNotification){
                widget.callBack(options[currentPage]);
              }
              return true;
            },
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: PageView.builder(
                reverse: true,
                onPageChanged: (pos) {
                  setState(() {
                    currentPage = pos;
                    widget.callBack(options[currentPage]);
                  });
                },
                controller: pageController,
                itemCount: options.length,
                itemBuilder: (context, index) {
                  final scale = max(SCALE_FRACTION, (FULL_SCALE - (index - page).abs()) + viewPortFraction);
                  return circleOffer(scale, index, options[index]);
                },
              ),
            ),
          ),
        ),
        //Center(child: Text(list[page.round()], style: TextStyle(color: Colors.white),)),

      ],
    );
  }

  Widget circleOffer(double scale, int index, String text) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: PAGER_HEIGHT * scale,
        width: PAGER_HEIGHT * scale,
        color: Colors.transparent,
        child: GestureDetector(
          onTap: (){
            pageController.animateToPage(
              index,
              curve: Curves.ease,
              duration: const Duration(milliseconds: 500),
            );
          },
          child: CircleAvatar(
              backgroundColor: Colors.white.withOpacity(0.3),
              child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontSize:
              text.length > 5 ? 17.0*scale : 20.0*scale),))
          ),
        ),
      ),
    );
  }
}
