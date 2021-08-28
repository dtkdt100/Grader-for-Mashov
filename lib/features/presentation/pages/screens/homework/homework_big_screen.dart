import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/user_data/homework.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:wakelock/wakelock.dart';

class HomeworkBigScreen extends StatefulWidget {
  final Homework homework;
  final int index;

  const HomeworkBigScreen({Key? key, required this.index, required this.homework}) : super(key: key);

  @override
  State<HomeworkBigScreen> createState() => _HomeworkBigScreenState();
}

class _HomeworkBigScreenState extends State<HomeworkBigScreen> {
  Widget _flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,
      ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }


  @override
  void initState() {
    Wakelock.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: Scaffold(
        appBar: AppBar(
          leading: RotatedBox(
            quarterTurns: 3,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: SharedPreferencesUtilities.themes.opacity == 0.2 ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                SystemChrome.setEnabledSystemUIMode(
                    SystemUiMode.manual, overlays: SystemUiOverlay.values);
              },
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Hero(
          flightShuttleBuilder: _flightShuttleBuilder,
          tag: widget.index,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: RotatedBox(
              quarterTurns: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        widget.homework.subject,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.homework.date.day}/${widget.homework.date.month}/${widget.homework.date.year}',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          widget.homework.message,
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

