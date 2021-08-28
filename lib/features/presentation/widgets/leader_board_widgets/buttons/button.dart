import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'animated_button.dart';

class Button extends StatelessWidget {
  static Widget classicButtonDesign(String text) => Container(
    height: 55,
    decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: SharedPreferencesUtilities.themes.colorGradient,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(17))),
    child: Center(
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700),
      ),
    ),
  );

  Button({Key? key,
    required BuildContext context,
    required String text,
    required LinearGradient linearGradient,
    Duration duration = const Duration(milliseconds: 350),
    double? newWidth,
    VoidCallback? onTap,
    TextStyle style = const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700),
  })  : onPressed = onTap,
        child = AnimatedContainer(
          duration: duration,
          width: newWidth ?? MediaQuery.of(context).size.width,
          height: 55,
          decoration: BoxDecoration(
              gradient: linearGradient,
              borderRadius: const BorderRadius.all(Radius.circular(17))),
          child: Center(
            child: Text(
              text,
              style: style,
            ),
          ),
        ), super(key: key);

  // ignore: use_key_in_widget_constructors
  Button.bottom(
      {required String path, required String text, required VoidCallback onTap})
      : onPressed = onTap,
        child = Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: const BorderRadius.all(Radius.circular(26))),
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  path,
                  height: 45,
                  width: 45,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        );

  Button.small({Key? key,
    required Widget child,
    required LinearGradient gradient,
    required VoidCallback onTap,
    double circular = 19,
  }) : onPressed = onTap,
        child = Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.all(Radius.circular(circular)),
          ),
          child: child,
        ), super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(child: child, onTap: onPressed);
  }
}