import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/pop_up_information/pop_up_information.dart';
import '../../../../../utilities/cloud/mashov_utilities.dart';
import '../../../../../utilities/phone/shared_preferences_utilities.dart';
import 'package:like_button/like_button.dart';

class LeaderBoardPositions extends StatefulWidget {
  final bool isAll;
  final List<Map<String, dynamic>> positions;

  const LeaderBoardPositions(this.positions, {Key? key, required this.isAll})
      : super(key: key);

  @override
  State<LeaderBoardPositions> createState() => _LeaderBoardPositionsState();
}

class _LeaderBoardPositionsState extends State<LeaderBoardPositions> {
  TextStyle styleTitle = const TextStyle(
      color: Colors.white,
      letterSpacing: 0.2,
      fontWeight: FontWeight.bold,
      fontSize: 28.0);

  TextStyle styleBody = const TextStyle(
      color: Colors.black,
      letterSpacing: 0.2,
      fontWeight: FontWeight.bold,
      fontSize: 16.0);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView(
        padding: EdgeInsets.zero,
        children: List.generate(widget.positions.length + 1, (index) {
          if (index == 0) {
            return Container(height: 25);
          }
          index -= 1;
          bool same = widget.positions[index]["id"] ==
              MashovUtilities.loginData!.data.userId;
          if (same) {
            styleBody = styleBody.copyWith(
                color: ThemeUtilities.themes.darkMode
                    ? Colors.black
                    : Colors.white);
          } else {
            styleBody = styleBody.copyWith(
                color: ThemeUtilities.themes.darkMode
                    ? Colors.white
                    : Colors.black);
          }

          return AnimationConfiguration.staggeredList(
            position: index,
            child: FlipAnimation(
              child: SlideAnimation(
                child: Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 20),
                  color: same
                      ? Colors.lightBlue
                          .withOpacity(ThemeUtilities.themes.opacity)
                      : ThemeUtilities.themes.backgroundColor,
                  child: Row(
                    children: [
                      Spacer(
                        flex: index == 0 ? 3 : 4,
                      ),
                      decidePositionWidget(index),
                      const Spacer(
                        flex: 3,
                      ),
                      CircleAvatar(
                        backgroundColor: same
                            ? Colors.white
                                .withOpacity(ThemeUtilities.themes.opacity)
                            : Colors.blue
                                .withOpacity(ThemeUtilities.themes.opacity),
                        child: Center(
                          child: Text(
                            widget.positions[index]["name"][0],
                            style: TextStyle(color: same ? Colors.black : Colors.white),
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Expanded(
                        flex: 16,
                        child: PopUpInformation(
                          informationChild: Container(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(widget.positions[index]["name"], style: styleBody),
                            ),
                          ),
                          child: Text(
                            widget.positions[index]["name"],
                            style: styleBody,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      Text(
                        widget.positions[index]["avg"].toString().substring(
                            0,
                            widget.positions[index]["avg"].toString().length == 3
                                ? 3
                                : 4),
                        style: styleBody,
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                      LikeButton(
                        likeBuilder: (b) {
                          return Icon(
                            Icons.star,
                            color: b
                                ? Colors.yellow[600]
                                : same
                                    ? Colors.white
                                    : Colors.black,
                          );
                        },
                      ),
                      widget.isAll
                          ? const Spacer(
                              flex: 2,
                            )
                          : const SizedBox(),
                      widget.isAll
                          ? Text(widget.positions[index]["ageGroup"])
                          : const SizedBox(),
                      //Icon(Icons.star, color: styleBody.color,),
                      Spacer(
                        flex: widget.isAll ? 2 : 4,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget decidePositionWidget(int index){
     if (index == 0) {
       return Icon(MdiIcons.trophy, size: 18, color: styleBody.color);
     } else {
       return Text(
         '${index + 1}',
         style: styleBody
       );
     }
  }
}
