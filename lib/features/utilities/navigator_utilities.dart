import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class NavigatorUtilities {
  final Widget destination;

  NavigatorUtilities(this.destination);

  Future<void> pushDefault(BuildContext context) async => await Navigator.push(
      context, MaterialPageRoute(builder: (_) => destination));

  Future<void> pushReplacementDefault(BuildContext context) async =>
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => destination));

  Future<void> pushReplacementWithNoAnimation(BuildContext context) async => await Navigator.pushReplacement(
      context,
      PageTransition(
          type: PageTransitionType.fade,
          child: destination,
          duration: const Duration(milliseconds: 0)));
}
