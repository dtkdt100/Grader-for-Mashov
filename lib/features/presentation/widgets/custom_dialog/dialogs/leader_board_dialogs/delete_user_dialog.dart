import '../../custom_dialog.dart';

class DeleteUserDialog extends CustomDialog<String> {
  DeleteUserDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    contentPadding: EdgeInsets.zero,
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('התנתקות', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 5,),
          Text('האם ברצונך להתנתק מתחרות הממוצעים?')
        ],
      ),
    ),
    actions: [
      TextButton(
        child: const Text('ביטול'),
        onPressed: () => Navigator.pop(context),
      ),
      TextButton(
        onPressed: () => Navigator.pop(context, true),
        child: const Text('התנתק'),
      ),
    ],
  );

}