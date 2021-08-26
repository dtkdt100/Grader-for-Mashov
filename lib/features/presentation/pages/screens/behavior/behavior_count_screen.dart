import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_behavior/one_line_behavior_sorted.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';

class BehaviorCountScreen extends StatefulWidget {
  final int indexPage;

  const BehaviorCountScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _BehaviorCountScreenState createState() => _BehaviorCountScreenState();
}

class _BehaviorCountScreenState extends BaseScreen<BehaviorCountScreen> {
  List<BehaveCounter>? hours;
  int weeklyHours = 0;
  int totalHours = 0;

  @override
  int get from => widget.indexPage;

  @override
  String get title => 'מונה אירועים';

  @override
  Widget? get flexibleSpace => FlexibleSpaceAppBar(
    items: [
      FlexibleSpaceAppBarItem(
        mainNumber: weeklyHours.toString(),
        description: 'שעות שבועיות',
        color: Colors.red,
      ),
      FlexibleSpaceAppBarItem(
        mainNumber: totalHours.toString(),
        description: 'שעות עד כה',
        color: Colors.green,
      ),
    ],
  );

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;

  @override
  Widget? get body => hours == null ? null : Column(
    children: List.generate(hours!.length, (index) {
      return OneLineBehaviorSorted(
        str1: ' :סה"כ שיעורים',
        str2: ' :שיעורים שבועיים',
        behavesForShort: {
          'value': hours![index].subject,
          'yesEvents':  hours![index].lessonsCount.toString(),
          'noEvents': hours![index].weeklyHours.toString(),
          'all': hours![index].totalEvents.toString(),
        },
        // behavesForShort: [hours![index].subject, hours![index].lessonsCount.toString(),
        //   hours![index].weeklyHours.toString(), hours![index].totalEvents.toString(),],
      );
    }),
  );

  @override
  Future<void> getMashovData() async {
    var result = await MashovUtilities.getBehavesCount();

    setState(() {
      hours = result['hours'];
      weeklyHours = result['weeklyHours'];
      totalHours = result['totalHours'];
    });
  }

  @override
  void reload() {
    hours = null;
    weeklyHours = 0;
    totalHours = 0;
    setState(() {});
    super.reload();
  }
}
