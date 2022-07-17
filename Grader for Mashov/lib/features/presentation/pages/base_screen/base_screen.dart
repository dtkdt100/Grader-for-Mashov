import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../grader_drawer/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pickers/three_dots_picker.dart';
import '../../../../utilities/phone/shared_preferences_utilities.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  Widget? leading;
  Widget? flexibleSpace;
  double? expandedHeight;
  PreferredSizeWidget? bottom;
  Widget? bottomNavigationBar;
  Widget? floatingActionButton;
  Widget? adWidget;
  List<String> threeDotsLabels = ['רענן'];


  Widget? body;
  late String title;
  late int from;

  @override
  void initState() {
    getMashovData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeUtilities.themes.themeData,
      child: Scaffold(
        drawer: GraderDrawer(from),
        floatingActionButton: floatingActionButton,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: ThemeUtilities.themes.colorAppBar,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 5.0,
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: 'פתח מגירת אפשרויות',
                  );
                },
              ),
              forceElevated: true,
              bottom: bottom,
              actions: [ThreeDotsPicker(
                children: threeDotsLabels,
                selected: selected,
              )],
              title: Text(title, style: const TextStyle(fontSize: 21)),
              expandedHeight: expandedHeight,
              flexibleSpace: flexibleSpace,
            ),
          ],
          body: body == null ? buildLoadingWidget() : Column(
            children: [
              adWidget ?? const SizedBox(),
              Expanded(
                child: SingleChildScrollView(
                  child: body,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }

  Widget buildLoadingWidget() => Center(
    child: CircularProgressIndicator(
      color: ThemeUtilities.themes.colorAppBar,
    ),
  );

  Future<void> getMashovData();

  void selected(int i) {
    switch(i) {
      case 0: reload();
    }
  }

  void reload() {
    getMashovData();
  }
}