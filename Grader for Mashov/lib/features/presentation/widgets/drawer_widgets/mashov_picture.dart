import 'dart:io';

import 'package:flutter/material.dart';
import '../custom_dialog/dialogs/drawer_dialogs/change_photo_dialog.dart';

class MashovPicture extends StatelessWidget {
  final ValueNotifier<String?> filePath;
  const MashovPicture({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: filePath,
      builder: (context, String? path, Widget? child) {
        return Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.grey, width: 0.5),
              borderRadius: BorderRadius.circular(5)),
          margin: const EdgeInsets.only(left: 0, top: 10, right: 10),
          child: path == null
              ? const SizedBox()
              : Stack(
            children: <Widget>[
              Container(
                height: 145,
                width: 2000,
                padding: const EdgeInsets.all(5),
                child: Ink.image(
                  fit: BoxFit.cover,
                  image: FileImage(File(path)),
                  child: InkWell(
                    onTap: (){
                      ChangePhotoDialog().showWithAnimation(context, value: filePath);
                    },
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.cached,
                      size: 20,
                      color: Colors.black,
                    )
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
