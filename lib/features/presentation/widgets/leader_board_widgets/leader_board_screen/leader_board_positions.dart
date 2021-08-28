import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
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
    return ListView(
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
              color: SharedPreferencesUtilities.themes.darkMode
                  ? Colors.black
                  : Colors.white);
        } else {
          styleBody = styleBody.copyWith(
              color: SharedPreferencesUtilities.themes.darkMode
                  ? Colors.white
                  : Colors.black);
        }

        return Container(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          color: same
              ? Colors.lightBlue.withOpacity(SharedPreferencesUtilities.themes.opacity)
              : SharedPreferencesUtilities.themes.backgroundColor,
          child: Row(
            children: [
              const Spacer(
                flex: 4,
              ),
              Text(
                '${index + 1}',
                style: styleBody,
              ),
              const Spacer(
                flex: 3,
              ),
              CircleAvatar(
                backgroundColor: same
                    ? Colors.white.withOpacity(SharedPreferencesUtilities.themes.opacity)
                    : Colors.blue.withOpacity(SharedPreferencesUtilities.themes.opacity),
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
                child: Text(
                  widget.positions[index]["name"],
                  style: styleBody,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              Text(
                widget.positions[index]["avg"].toString().substring(0, 4),
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
        );
      }),
    );
  }
}
