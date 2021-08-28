import '../custom_dialog.dart';

class NewAvgDialog extends CustomDialog<String> {
  NewAvgDialog() : super(dialog);

  static Widget dialog(BuildContext context, {String? value}) => AlertDialog(
    content: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("הממוצע שלך הוא:", textAlign: TextAlign.center, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),),
          const SizedBox(height: 25,),
          Text(value!, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w500),),
          const SizedBox(height: 7,),
        ],
      ),
    ),
  );

}