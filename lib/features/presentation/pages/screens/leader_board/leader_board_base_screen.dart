import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/grader_drawer.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/loading_page.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

abstract class LeaderBoardBaseScreen<T extends StatefulWidget> extends State<T> {
  Duration animationDuration = const Duration(milliseconds: 350);
  bool opacity = false;

  static double controllerSize = 130.0;
  double topHeader = 15.0 - controllerSize;

  final Widget nothingWidget = Container(color: Colors.transparent, width: 0, height: 0,);

  Widget? centerWidget;
  Widget? headerWidget;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 100),(){
      animateIn();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: Stack(
        children: [
          LoadingPage.backgroundDesign(),
          Scaffold(
            backgroundColor: Colors.transparent,
            endDrawer: const GraderDrawer(3),
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                centerWidget == null ? nothingWidget : buildCenterWidget(),
                headerWidget == null ? nothingWidget : buildHeaderWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeaderWidget() => AnimatedPosition(
    opacity: opacity,
    top: topHeader,
    duration: animationDuration,
    child: headerWidget!,
  );

  Widget buildCenterWidget() => Stack(
    children: [
      Center(
        child: AnimatedOpacity(
          child: centerWidget!,
          opacity: opacity ? 1 : 0,
          duration: animationDuration,
        ),
      ),
    ],
  );

  void animateIn() {
    setState(() {
      opacity = true;
      topHeader += controllerSize;
    });
  }

  void animateOut([VoidCallback? callback]) {
    setState(() {
      opacity = false;
      topHeader -= controllerSize;
    });
    if (callback != null) {
      Future.delayed(animationDuration, callback);
    }
  }
}

class AnimatedPosition extends StatelessWidget {
  final Widget child;

  final double? top;
  final double? bottom;
  final double? right;
  final double? left;

  final bool opacity;
  final Duration duration;

  const AnimatedPosition({
    required this.child,
    required this.opacity,
    this.top,
    this.bottom,
    this.right,
    this.left,
    this.duration = const Duration(milliseconds: 350),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      right: right,
      left: left,
      top: top,
      width: MediaQuery.of(context).size.width,
      bottom: bottom,
      child: AnimatedOpacity(
        opacity: opacity ? 1 : 0,
        duration: duration,
        child: child,
      ),
      duration: duration,
    );
  }
}