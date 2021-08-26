import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/behave_event.dart';

class OneLineBehavior extends StatelessWidget {
  final BehaveEvent event;

  const OneLineBehavior({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  top: 7,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'שיעור ${event.lesson}',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                        '${event.date.day}.${event.date.month}.${event.date.year}',
                        style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 6, bottom: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      event.text,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          decoration: event.justificationId > -1
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationThickness: 2,
                          fontSize: 15),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${event.subject}(${event.reporter})',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 2,
          thickness: 0.8,
        )
      ],
    );
  }
}