import '../../custom_dialog.dart';

class ErrorLoginDialog extends CustomDialog<String> {
  ErrorLoginDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('יש שגיאה', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          Text('בדוק את פרטיך לפני ההתחברות.\nהתקלה יכולה לקרות משני סיבות: לא יכולנו לחשב את הממוצע שלך או לא הצלחנו למצוא את שכבת הגיל שלך.')
        ],
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