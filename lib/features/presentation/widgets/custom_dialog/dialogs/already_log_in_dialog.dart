import '../custom_dialog.dart';

class AlreadyLogInDialog extends CustomDialog<String> {
  AlreadyLogInDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('הגירסה החדשה - 3.00', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5,),
            Text('יש כל כך הרבה דברים חדשים! אך כדי לראות אותם, תצטרך/כי להיכנס לגריידר עוד הפעם.')
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('הבנתי'),
      ),
    ],
  );

}