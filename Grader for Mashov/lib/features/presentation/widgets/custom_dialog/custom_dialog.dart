import 'dart:ui';
export 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import '../../../../utilities/phone/shared_preferences_utilities.dart';

abstract class CustomDialog<E> {
  final Function(BuildContext context, {E? value}) child;

  CustomDialog(this.child);

  Future<void> show(BuildContext context, {E? value}) async {
    await showDialog<void>(
      context: context,
      builder: (context) => buildChild(context, value)
    );
  }

  Future<T?> showWithAnimation<T extends Object?>(BuildContext context, {E? value}) async {
    return await showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 400, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: buildChild(context, value),
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) => const SizedBox(),
    );
  }

  Widget buildChild(BuildContext context, E? value) => Theme(
    data: ThemeUtilities.themes.themeData.copyWith(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,),
    child: child(context, value: value),
  );
}