import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_behavior/one_line_behavior_sorted.dart';
import '../../../widgets/pickers/fab_circular_menu/custom_fab_circular_menu.dart';
import 'package:grader_for_mashov_new/utilities/sort/behavior/behavior_sort_by_subject_sort_utilities.dart';
import 'package:grader_for_mashov_new/utilities/sort/behavior/behavior_sort_utilities.dart';
import '../../../widgets/one_line/one_line_behavior/one_line_behavior.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';

enum SortMehtod { none, yesEvents, noEvents}

class BehaviorScreen extends StatefulWidget {
  final int indexPage;

  const BehaviorScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _BehaviorScreenState createState() => _BehaviorScreenState();
}

class _BehaviorScreenState extends BaseScreen<BehaviorScreen> {
  int page = 0;
  int yesEvents = 0;
  int noEvents = 0;

  List<BehaveEvent>? events;
  List<Map<String, dynamic>>? behavesForSubjects;
  List<Map<String, dynamic>>? behavesForEvents;

  SortMehtod _sortMehtod = SortMehtod.none;

  @override
  String get title => 'אירועי התנהגות';

  @override
  int get from => widget.indexPage;

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;

  @override
  List<String> get threeDotsLabels {
    super.threeDotsLabels = ['רענן', 'הכל', 'לפי מקצוע ', 'לפי אירוע '];
    return super.threeDotsLabels;
  }

  @override
  Widget? get floatingActionButton => CustomFabCircularMenu(
    items: page == 0 ? itemsForAll() : itemsForSortSubject(page == 1 ? behavesForSubjects! : behavesForEvents!)
  );

  List<CustomFabItem> itemsForAll() => [
    CustomFabItem(
        iconData: Icons.access_alarm,
        onTap: (){
          _sortMehtod = SortMehtod.none;
          BehaviorSortUtilities(events!).sortByDate();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: Icons.check,
        onTap: (){
          _sortMehtod = SortMehtod.yesEvents;
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: Icons.close,
        onTap: (){
          _sortMehtod = SortMehtod.noEvents;
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: Icons.group,
        onTap: (){
          _sortMehtod = SortMehtod.none;
          BehaviorSortUtilities(events!).sortBySubject();
          setState(() {});
        }
    ),
  ];

  List<CustomFabItem> itemsForSortSubject(List<Map<String, dynamic>> list) => [
    CustomFabItem(
        iconData: MdiIcons.sortAlphabeticalAscendingVariant,
        onTap: () {
          GradesSortedBySubjectSortUtilities(list).sortByAlphaBet();
          setState(() {});
        }
    ),
    CustomFabItem(
        iconData: MdiIcons.sortNumericAscendingVariant,
        onTap: (){
          GradesSortedBySubjectSortUtilities(list).sortByEvents();
          setState(() {});
        }
    ),
  ];

  @override
  Widget? get flexibleSpace => FlexibleSpaceAppBar(
        items: [
          FlexibleSpaceAppBarItem(
            color: Colors.green,
            description: 'מצודקים',
            mainNumber: yesEvents.toString(),
          ),
          FlexibleSpaceAppBarItem(
            color: Colors.red,
            description: 'לא מצודקים',
            mainNumber: noEvents.toString(),
          ),
        ],
      );

  @override
  Widget? get body => events == null
      ? null
      : page == 0
          ? bodyAll()
          : page == 1
              ? bodySort(behavesForSubjects!)
              : bodySort(behavesForEvents!);

  Widget bodyAll() {
    return Column(
      children: List.generate(events!.length, (index) {
        if (_sortMehtod == SortMehtod.yesEvents && events![index].justificationId > -1) {
          return const SizedBox();
        } else if (_sortMehtod == SortMehtod.noEvents && !(events![index].justificationId > -1)){
          return const SizedBox();
        }
        return OneLineBehavior(
          event: events![index],
        );
      }),
    );
  }

  Widget bodySort(List<Map<String, dynamic>> list) {
    return Column(
      children: List.generate(list.length, (index) {
        return OneLineBehaviorSorted(
          behavesForShort: list[index],
        );
      }),
    );
  }

  @override
  Future<void> getMashovData() async {
    var result = await MashovUtilities.getBehaves();

    setState(() {
      yesEvents = result['yesEvents'];
      noEvents = result['noEvents'];
      events = result['events'];
      behavesForSubjects = result['behavesForSubjects'];
      behavesForEvents = result['behavesForEvents'];
    });
  }

  @override
  void reload() {
    events = null;
    noEvents = 0;
    yesEvents = 0;
    setState(() {});
    super.reload();
  }

  @override
  void selected(int i) {
    if (i != 0) {
      setState(() {
        page = i-1;
      });
    }
    super.selected(i);
  }
}
