import 'package:flutter/material.dart';

class OneLineBehaviorSorted extends StatelessWidget {
  final Map<String, dynamic> behavesForShort;
  final String str1, str2;

  const OneLineBehaviorSorted({Key? key,
    required this.behavesForShort,
    this.str1 = "מוצדקים: ",
    this.str2 = "לא מוצדקים: ",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(right: 10, top: 7, bottom: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${behavesForShort['value']}',
                      style:
                      const TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                    ),
                    Text('$str1${behavesForShort['yesEvents']}',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                    Text('$str2${behavesForShort['noEvents']}',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontSize: 15)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '${behavesForShort['all']}',
                    style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  Text(
                    'אירועי התנהגות',
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
  }
}