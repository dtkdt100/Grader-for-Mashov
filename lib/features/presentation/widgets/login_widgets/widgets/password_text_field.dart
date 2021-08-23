import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/material_design_icons_flutter/material_design_icons_flutter.dart';

class PasswordSetting {
  final bool isPassword;

  String hintText;
  IconData iconData;
  String loginText;
  TextInputType textInputType;

  PasswordSetting(this.isPassword)
      : hintText = isPassword ? "סיסמא" : "מספר טלפון",
        iconData = isPassword ? Icons.lock : Icons.phone,
        loginText = isPassword ? "כניסה באמצעות SMS" : "כניסה באמצעות סיסמא",
        textInputType =
        isPassword ? TextInputType.visiblePassword : TextInputType.phone;
}

class PasswordTextField extends StatefulWidget {
  final bool enable, isPassword;

  const PasswordTextField({Key? key, required this.enable, required this.isPassword}) : super(key: key);

  @override
  PasswordTextFieldState createState() => PasswordTextFieldState();
}

class PasswordTextFieldState extends State<PasswordTextField> {
  FocusNode focusNode = FocusNode();
  TextEditingController textEditingControllerPassWord = TextEditingController();
  bool visiblePassword = false;
  String? hintPasswordNew;
  String? errorPasswordText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
      child: Row(
        children: <Widget>[
          Icon(PasswordSetting(widget.isPassword).iconData),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextField(
              controller: textEditingControllerPassWord,
              focusNode: focusNode,
              enabled: widget.enable,
              obscureText: widget.isPassword ? !visiblePassword : false,
              keyboardType: PasswordSetting(widget.isPassword).textInputType,
              decoration: InputDecoration(
                  hintText: hintPasswordNew ?? PasswordSetting(widget.isPassword).hintText,
                  errorText: errorPasswordText),
              onChanged: (value) {
                // bool hasDigits = value.contains(RegExp(r'[0-9]'));
                // bool hasLetters = value.contains(RegExp(r'[a-z]|[A-Z]'));
                // if (!hasLetters || !hasDigits) {
                //   errorPasswordText = "סיסמא אינה תקינה";
                // }

                setState(() {
                  errorPasswordText = null;
                  //password = value;
                });
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          // GestureDetector(
          //   child: Stack(
          //     children: [
          //       Icon(
          //         Icons.remove_red_eye_outlined,
          //         size: 28,
          //       ),
          //       Container(
          //         width: 28,
          //         height: 28,
          //         child: ifItIsOnTheFirstTime
          //             ? Container()
          //             : CustomPaint(painter: LinePainter(_progress, 3)),
          //       ),
          //     ],
          //   ),
          //   //child:
          //   onTap: () {
          //     ifItIsOnTheFirstTime = false;
          //     if (controller2.isCompleted) {
          //       controller2.reverse();
          //     } else {
          //       controller2.forward();
          //     }
          //     setState(() {
          //       visiblePassword = !visiblePassword;
          //     });
          //   },
          // ),
          Visibility(
            visible: widget.isPassword,
            child: IconButton(
              icon: Icon(!visiblePassword
                  ? Icons.remove_red_eye_outlined
                  : MdiIcons.eyeOffOutline),
              onPressed: () {
                setState(() {
                  visiblePassword = !visiblePassword;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
