import '../custom_dialog.dart';

class InformationDialog extends CustomDialog<String> {
  InformationDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('סיסמא חד פעמית נשלחה בהצלחה', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5,),
            Text('יש להשתמש בסיסמה שקיבלת על-מנת להתחבר.')
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