import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

class CardDesign extends StatelessWidget {
  final String title;
  final VoidCallback callback;
  final Widget? child;
  final bool removeBottom;

  const CardDesign({Key? key,
    required this.title,
    required this.callback,
    required this.child,
    this.removeBottom = false,
  }) : super(key: key);

  static const seeMoreColor =  Color(0xFFffac52);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ElevatedButton(
                child: const Text(
                  'ראה עוד',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: callback,
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      seeMoreColor.withOpacity(SharedPreferencesUtilities.themes.opacity),
                    )),
                //color: Color(0xFFffac52).withOpacity(theme.opacity),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: callback,
          child: Card(
            elevation: 4,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: child ?? Row(
                children: [
                  const Spacer(),
                  CircularProgressIndicator(color: SharedPreferencesUtilities.themes.colorAppBar,),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          height: removeBottom ? 0 : 30,
        ),
      ],
    );
  }
}
