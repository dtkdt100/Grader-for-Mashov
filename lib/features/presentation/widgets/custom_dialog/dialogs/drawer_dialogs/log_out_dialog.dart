import 'package:grader_for_mashov_new/features/presentation/pages/loading_page.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

class LogOutDialog extends CustomDialog<String> {
  LogOutDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('התנתקות', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          Text('האם ברצונך להתנתק מהאפליקציה?')
        ],
      ),
    ),
    actions: [
      TextButton(
        child: const Text('ביטול'),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
      TextButton(
        child: const Text('התנתק'),
        onPressed: () async {
          NavigatorUtilities(LoadingPage(
            doBefore: () async {
              await MashovUtilities.logOut();
              await SharedPreferencesUtilities.clearAllPreferences();
            },
          )).pushReplacementWithNoAnimation(context);
        },
      ),
    ],
  );
}