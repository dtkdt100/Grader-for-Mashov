import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/home_page.dart';
import '../../custom_dialog/bottom_dialogs/bottom_flash_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/login_widgets/widgets/password_text_field.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/navigator_utilities.dart';
import 'package:grader_for_mashov_new/features/utilities/shared_preferences_utilities.dart';
import 'package:simple_animations/simple_animations.dart';

class BottomButtons extends StatefulWidget {
  final bool isPassword;
  final VoidCallback changeIsPassword;
  final VoidCallback receiveCode;
  final LoginDetails loginDetails;
  final bool canRemember;

  const BottomButtons(
      {Key? key, required this.isPassword, required this.changeIsPassword,
        required this.loginDetails, required this.receiveCode, required this.canRemember})
      : super(key: key);

  @override
  _BottomButtonsState createState() => _BottomButtonsState();
}

class _BottomButtonsState extends State<BottomButtons> {
  bool keepPassword = true;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (!(widget.isPassword && widget.canRemember)) {
      keepPassword = false;
    }
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 5),
          child: InkWell(
            onTap: () {
              setState(() {
                if (widget.isPassword) {
                  keepPassword = !keepPassword;
                }
              });
            },
            child: Row(
              children: <Widget>[
                Transform.scale(
                  scale: 1.2,
                  child: Checkbox(
                    value: keepPassword,
                    onChanged: (bool? newValue) {
                      setState(() {
                        if (widget.isPassword && widget.canRemember) {
                          keepPassword = !keepPassword;
                        }
                      });
                    },
                  ),
                ),
                const Expanded(
                    child: Text(
                      'זכור אותי',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w500),
                    )),
              ],
            ),
          ),
        ),
        buildButton('כניסה', 20,
          onTap: login,
          child: !isLoading ? null : const Padding(
            padding: EdgeInsets.only(
                right: 10, left: 10, top: 8, bottom: 8),
            child: LinearProgressIndicator(
              minHeight: 5,
            ),
          ),
        ),
        buildButton(PasswordSetting(widget.isPassword).loginText, 10,
          onTap: (){
            widget.changeIsPassword();
            setState(() {
              if (!widget.isPassword) keepPassword = true;
            });
          }
        ),
      ],
    );
  }


  Widget buildButton(String text, double padding, {Widget? child, required VoidCallback onTap}) => Padding(
    padding: const EdgeInsets.only(bottom: 10, top: 5),
    child: Row(
      children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xFF03a9f4),
            ),
            onPressed: onTap,
            child: Padding(
              padding: EdgeInsets.only(top: padding, bottom: padding),
              child: child ?? Text(text, style: const TextStyle(color: Colors.black),),
            ),
          ),
        ),
      ],
    ),
  );

  Future<void> login() async {
    if (!isLoading && widget.loginDetails.isAllNotNull()) {
      if (widget.isPassword) {
        bool succeed = await handleTap(() async {
          return await MashovUtilities.login(widget.loginDetails);
        });
        if (succeed) handleSuccessLogin();

      } else {
        bool succeed = await handleTap(() async {
          return await MashovUtilities.sendCode(widget.loginDetails);
        });

        if (succeed) widget.receiveCode();
      }
    }
  }

  void handleSuccessLogin() {
    if (keepPassword) {
      widget.loginDetails.uniqueId = MashovUtilities.loginData!.data.uniqueId;
      SharedPreferencesUtilities.setLoginData(widget.loginDetails);
    }

    NavigatorUtilities(const HomePage()).pushReplacementDefault(context);
  }

  Future<bool> handleTap(Future<bool> Function() function) async {
    setState(() {
      isLoading = !isLoading;
    });

    bool isSucceed = await function();

    if(!isSucceed) handleError();

    setState(() {
      isLoading = !isLoading;
    });

    return isSucceed;

  }

  void handleError() => BottomFlashDialog.show(context);

}
