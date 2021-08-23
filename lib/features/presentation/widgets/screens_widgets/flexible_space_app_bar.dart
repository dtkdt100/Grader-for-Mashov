import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

class FlexibleSpaceAppBar extends StatelessWidget {
  static double expandedHeight = 170;

  final List<FlexibleSpaceAppBarItem> items;

  const FlexibleSpaceAppBar({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                end: Alignment.bottomLeft, colors: SharedPreferencesUtilities.themes.colorGradient)),
        child: Column(
          children: [
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(items.length, (index) {
                return Column(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: items[index].color,
                      radius: 6.5,
                    ),
                    Text(
                      items[index].mainNumber,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: items[index].mainNumber == 'אין נתונים' ? 35 : 40,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      items[index].description,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }
}

class FlexibleSpaceAppBarItem {
  String mainNumber;
  final String description;
  final Color color;

  FlexibleSpaceAppBarItem({
    this.color = Colors.transparent,
    required this.description,
    required this.mainNumber,
  });
}
