import 'package:flutter/cupertino.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_homework.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';

class HomeworkScreen extends StatefulWidget {
  final int indexPage;
  const HomeworkScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _HomeworkScreenState createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends BaseScreen<HomeworkScreen> {
  List<Homework>? homeWorks;

  @override
  String get title => 'שיעורי בית';

  @override
  int get from => widget.indexPage;

  @override
  Widget? get body => homeWorks == null ? null : Directionality(
    textDirection: TextDirection.rtl,
    child: Column(
      children: List.generate(homeWorks!.length, (index) {
        return OneLineHomework(
          index: index,
          homework: homeWorks![index],
        );
      }),
    ),
  );

  @override
  Future<void> getMashovData() async {
    homeWorks = await MashovUtilities.getHomeWork();
    setState(() {

    });
  }

  @override
  void reload() {
    homeWorks = null;
    setState(() {});
    super.reload();
  }
}
