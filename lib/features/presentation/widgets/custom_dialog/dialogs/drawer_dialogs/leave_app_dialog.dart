import 'package:flutter/services.dart';

import '../../custom_dialog.dart';

class LeaveAppDialog extends CustomDialog<String> {
  LeaveAppDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('יציאה', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5,),
            Text('האם ברצונך לצאת מהאפליקציה?')
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        child: const Text('צא'),
        onPressed: () => SystemNavigator.pop(),
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