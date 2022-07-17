import 'package:flutter/material.dart';
import '../../base_screen/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_behavior/one_line_behavior_sorted.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import '../../../../../../utilities/cloud/mashov_utilities.dart';

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
        mainNumber: totalHours.toString(),
        description: 'שעות עד כה',
        color: Colors.green,
      ),
      FlexibleSpaceAppBarItem(
        mainNumber: weeklyHours.toString(),
        description: 'שעות שבועיות',
        color: Colors.red,
      ),
    ],
  );

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;

  @override
  Widget? get body => hours == null ? null : Column(
    children: List.generate(hours!.length, (index) {
      return OneLineBehaviorSorted(
        str1: 'סה"כ שיעורים: ',
        str2: 'שיעורים שבועיים: ',
        behavesForShort: {
          'value': hours![index].subject,
          'yesEvents':  hours![index].lessonsCount.toString(),
          'noEvents': hours![index].weeklyHours.toString(),
          'all': hours![index].totalEvents.toString(),
        },
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
