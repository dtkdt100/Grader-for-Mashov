import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/leader_board/screens/leader_board_first_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/leader_board/screens/leader_board_screen.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:page_transition/page_transition.dart';

class NavigatorUtilities {
  final Widget destination;

  NavigatorUtilities(this.destination);

  Future<void> pushDefault(BuildContext context) async => await Navigator.push(
      context, MaterialPageRoute(builder: (_) => destination));

  Future<void> pushReplacementDefault(BuildContext context) async =>
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => destination));

  Future<void> pushReplacementWithNoAnimation(BuildContext context) async =>
      await Navigator.pushReplacement(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              child: destination,
              duration: const Duration(milliseconds: 0)));

  static Future<void> navigateToLeaderBoardScreen(BuildContext context) async =>
      await NavigatorUtilities(SharedPreferencesUtilities.connectedToLeaderBoard
              ? const LeaderBoardScreen()
              : const LeaderBoardFirstScreen())
          .pushDefault(context);
}
