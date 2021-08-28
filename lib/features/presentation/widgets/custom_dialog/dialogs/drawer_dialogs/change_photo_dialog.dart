import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';

import '../../custom_dialog.dart';
import 'package:image_picker/image_picker.dart';


class ChangePhotoDialog extends CustomDialog<ValueNotifier<String?>> {
  ChangePhotoDialog() : super(dialog);

  static List<String> names = ['צלם תמונה', 'בחר תמונה מן הגלריה (נדרשת גישה)', 'לקיחת התמונה מן המשוב'];

  static Widget dialog(BuildContext context, {ValueNotifier<String?>? value}) => AlertDialog(
    content: Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'בחר תמונה',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(names.length, (index) => InkWell(
              splashColor: Colors.grey[300],
              onTap: () async {
                handleTap(index, value);
                Navigator.pop(context);
              },
              child: SizedBox(
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    names[index],
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('אישור'),
      ),
    ],
  );

  static void handleTap(int i, ValueNotifier<String?>? value) async {
    String? path;
    if (i == 0) {
      var pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera);
      if (pickedFile != null) path = pickedFile.path;
    } else if (i == 1) {
      var pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery);
      if (pickedFile != null) path = pickedFile.path;
    } else {
      path = (await MashovUtilities.getPicture()).path;
    }

    if (path != null) {
      value!.value = path;
      value.notifyListeners();
      SharedPreferencesUtilities.setPicture(path);
    }

  }

}