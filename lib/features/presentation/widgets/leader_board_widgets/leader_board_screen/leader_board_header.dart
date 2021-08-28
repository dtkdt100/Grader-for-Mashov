import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pickers/leader_board_bottom_sheet.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'leader_board_selection.dart';

class LeaderBoardHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function(String) callBack;

  final VoidCallback restart;
  final VoidCallback load;

  const LeaderBoardHeader(
      {Key? key,
      required this.scaffoldKey,
      required this.callBack,
      required this.restart,
      required this.load})
      : super(key: key);

  @override
  State<LeaderBoardHeader> createState() => LeaderBoardHeaderState();
}

class LeaderBoardHeaderState extends State<LeaderBoardHeader> {
  GlobalKey<LeaderBoardSelectionState> keySelection = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Stack(
            children: [
              RotationTransition(
                turns: const AlwaysStoppedAnimation(180 / 360),
                child: WaveWidget(
                  config: CustomConfig(
                    gradients: [
                      SharedPreferencesUtilities.themes.colorGradient
                    ],
                    durations: [10000000000],
                    heightPercentages: [0],
                    blur: const MaskFilter.blur(BlurStyle.solid, 10),
                    gradientBegin: Alignment.bottomLeft,
                    gradientEnd: Alignment.topRight,
                  ),
                  waveAmplitude: 15,
                  size: const Size(
                    double.infinity,
                    double.infinity,
                  ),
                ),
              ),
              Center(
                  child: Icon(
                MdiIcons.trophy,
                color: Colors.white
                    .withOpacity(SharedPreferencesUtilities.themes.opacityIcon),
                size: 400,
              )),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          IconButton(
                              splashColor: Colors.grey,
                              tooltip: 'Open navigation menu',
                              onPressed: () {
                                widget.scaffoldKey.currentState!
                                    .openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                              )),
                          const Spacer(),
                          const Text("לוח תוצאות",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0.2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0)),
                          const Spacer(
                            flex: 4,
                          ),
                          IconButton(
                              tooltip: 'הגדרות',
                              onPressed: () async {
                                await LeaderBoardBottomSheet(
                                    restart: widget.restart,
                                    callBack: widget.load)
                                    .show(context);
                                // await bottomSheet(context, () {
                                //   callBack(ageGroupGlo);
                                // }, restart);
                              },
                              icon: const Icon(
                                Icons.settings,
                                color: Colors.white,
                              )),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: LeaderBoardSelection(
                    callBack: widget.callBack,
                    key: keySelection,
                  )),
                ],
              ),
            ],
          ),
        ),
        const Spacer(
          flex: 6,
        ),
      ],
    );
  }
}
