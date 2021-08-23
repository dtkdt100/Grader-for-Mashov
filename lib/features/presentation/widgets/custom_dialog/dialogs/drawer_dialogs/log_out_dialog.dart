import 'package:grader_for_mashov_new/core/mashov_api/mashov_api.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/loading_page.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/login_page.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';

class LogOutDialog extends CustomDialog<String> {
  LogOutDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('התנתקות', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5,),
            Text('האם ברצונך להתנתק מהאפליקציה?')
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        child: const Text('התנתק'),
        onPressed: () async {
          await MashovUtilities.logOut();
          await SharedPreferencesUtilities.clearAllPreferences();
          NavigatorUtilities(const LoadingPage()).pushReplacementWithNoAnimation(context);
        },
      ),
      TextButton(
        child: const Text('ביטול'),
        onPressed: (){
          Navigator.pop(context);
        },
      ),
    ],
  );
}