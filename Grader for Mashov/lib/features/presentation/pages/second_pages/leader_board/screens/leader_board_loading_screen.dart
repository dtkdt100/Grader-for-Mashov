import 'package:grader_for_mashov_new/features/presentation/pages/second_pages/leader_board/leader_board_base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/custom_dialog.dart';

typedef AnimateOutCallBack = void Function([VoidCallback? callback]);


class LeaderBoardLoadingScreen extends StatefulWidget {
  final Future<void> Function(BuildContext context, AnimateOutCallBack callBack) callBack;

  const LeaderBoardLoadingScreen({Key? key, required this.callBack}) : super(key: key);

  @override
  _LeaderBoardLoadingScreenState createState() => _LeaderBoardLoadingScreenState();
}

class _LeaderBoardLoadingScreenState extends LeaderBoardBaseScreen<LeaderBoardLoadingScreen> {

  @override
  void initState() {
    Future.delayed(animationDuration, () async {
      await widget.callBack(context, animateOut);
    });
    super.initState();
  }

  @override
  Widget? get centerWidget => const SizedBox(
    width: 55,
    height: 55,
    child: CircularProgressIndicator(
      color: Colors.white,
      strokeWidth: 7.0,
    ),
  );
}
