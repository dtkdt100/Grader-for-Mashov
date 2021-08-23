import 'package:grader_for_mashov_new/core/avg_game_controller/avg_game_controller.dart';
import 'package:grader_for_mashov_new/features/data/animation/material_ink_splash.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/custom_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/leader_board_dialogs/delete_user_dialog.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';
import '../custom_dialog/dialogs/leader_board_dialogs/change_name_dialog.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';

class LeaderBoardBottomSheet {
  final VoidCallback restart;
  final VoidCallback callBack;

  LeaderBoardBottomSheet({
    required this.restart,
    required this.callBack,
  });


  Widget _childDesign(String text, Function(BuildContext) onTap, BuildContext context, {Color textColor = Colors.black, Widget? child}){
    return Theme(
      data: Theme.of(context)
          .copyWith(splashFactory: MaterialInkSplash.splashFactory),
      child: InkWell(
        highlightColor: Colors.transparent,
        onTap: (){onTap(context);},
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(child: Text(text, style: TextStyle(fontFamily: '', fontSize: 17, color: textColor),)),
              child ?? const SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _changeName(BuildContext context) async {
    String? name = await ChangeNameDialog().showWithAnimation(context);
    if (name != null) {
      restart();
      await AvgGameController(MashovUtilities.loginData!.data).updateName(name);
      callBack();
    }
  }

  Future<void> deleteUser(context) async {
    bool? delete = await DeleteUserDialog().showWithAnimation(context);
    if (delete != null) {
      restart();
      await AvgGameController(MashovUtilities.loginData!.data).deleteUser();
      SharedPreferencesUtilities.setLeaderBoard(true);
      callBack();
    }
  }


  Future<void> show(BuildContext context) async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _childDesign("שנה שם", _changeName, context),
              _childDesign("התנתק מהמשחק", deleteUser, context, textColor: const Color(0xffdb3d54)),
              _childDesign("בטל", (c){Navigator.pop(context);}, context),
            ],
          ),
        );
      },
    );
  }
}