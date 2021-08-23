import 'package:flutter/material.dart';

import 'buttons/button.dart';

class LeaderBoardCard extends StatelessWidget {
  final Widget? child;
  final String? title;
  final List<String> lines;
  final Button? button;

  const LeaderBoardCard({Key? key, this.title, this.child, this.lines = const [], this.button}) : super(key: key);

  static TextStyle textStyleTitle = TextStyle(fontSize: 20, color: Colors.grey[600]);
  static double heightFromTitles = 19.0;
  static TextStyle textStyle = const TextStyle(fontSize: 15);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        margin: const EdgeInsets.all(5.0),
        padding: const EdgeInsets.all(3),
        child: Card(
          elevation: 1.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: buildCard(),
        ),
      ),
    );
  }

  Widget buildCard() => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title == null ? const SizedBox() : Center(
            child: Text(title!, style: textStyleTitle)),

        SizedBox(
          height: title != null ? heightFromTitles : 0,
        ),

        child ?? Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(lines.length, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lines[index], style: textStyle, textAlign: TextAlign.right,),
                index != lines.length-1 ? Divider(
                  height: 22.0,
                  thickness: 2.5,
                  color: Colors.grey[300]!,
                ) : const SizedBox(),
              ],
            );
          }),
        ),

        SizedBox(
          height: button != null ? heightFromTitles : 0,
        ),
        button ?? const SizedBox(),
      ],
    ),
  );
}
