import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pickers/three_dots_picker.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

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
      data: SharedPreferencesUtilities.themes.themeData,
      child: Scaffold(
        endDrawer: GraderDrawer(from),
        floatingActionButton: floatingActionButton,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: SharedPreferencesUtilities.themes.colorAppBar,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 5.0,
              forceElevated: true,
              bottom: bottom,
              leading: ThreeDotsPicker(
                children: threeDotsLabels,
                selected: selected,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(title, style: const TextStyle(fontSize: 21)),
                ],
              ),
              expandedHeight: expandedHeight,
              flexibleSpace: flexibleSpace,
            ),
          ],
          physics: const BouncingScrollPhysics(),
          body: body == null ? buildLoadingWidget() : Column(
            children: [
              adWidget ?? const SizedBox(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
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
      color: SharedPreferencesUtilities.themes.colorAppBar,
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