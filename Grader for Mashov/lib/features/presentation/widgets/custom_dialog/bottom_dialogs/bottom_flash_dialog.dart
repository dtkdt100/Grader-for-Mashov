import 'package:flash/flash.dart';
import 'package:flutter/material.dart';

class BottomFlashDialog {
  static void show(BuildContext context) {
    showFlash(
      context: context,
      persistent: true,
      duration: const Duration(seconds: 3),
      builder: (_, controller) {
        return Flash(
          controller: controller,
          // margin: const EdgeInsets.only(
          //     left: 12.0, right: 12.0, bottom: 34.0),
          // borderRadius: BorderRadius.circular(8.0),
          // borderColor: Colors.blue,
          // boxShadows: kElevationToShadow[8],
          // backgroundGradient: RadialGradient(
          //   colors: [Colors.red, Colors.red[700]!],
          //   center: Alignment.topLeft,
          //   radius: 2,
          // ),
          // onTap: () => controller.dismiss(),
          // alignment: Alignment.bottomCenter,
          position: FlashPosition.bottom,
          forwardAnimationCurve: Curves.easeInCirc,
          child: DefaultTextStyle(
            style: const TextStyle(color: Colors.white),
            child: FlashBar(
              title: const Text(
                'שגיאה בהתחברות',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('בדוק שוב את כל הפרטים ונסה שוב.'),
              ),
              primaryAction: TextButton(
                onPressed: () => controller.dismiss(),
                child: const Text('סגור'),
              ), controller: controller,
            ),
          ),
        );
      },
    );
  }
}
