import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/login/school.dart';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:grader_for_mashov_new/utilities/phone/shared_preferences_utilities.dart';
import '../../../../utilities/phone/theme_utilities.dart';
import 'loading_page.dart';
import '../../widgets/custom_dialog/dialogs/information_dialog.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/login_widgets/login_widgets.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/login_widgets/widgets/username_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginPage extends StatefulWidget {
  final List<School> schools;

  const LoginPage({Key? key, required this.schools}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<SchoolTextFieldState> keySchools = GlobalKey();
  GlobalKey<PasswordTextFieldState> keyPassword = GlobalKey();
  GlobalKey<UsernameTextFieldState> keyUsername = GlobalKey();

  bool isPassword = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (SharedPreferencesUtilities.loginDetails != null) {
        keySchools.currentState!.setSchool(
            SharedPreferencesUtilities.loginDetails!.school,
            SharedPreferencesUtilities.loginDetails!.year);
        keyUsername.currentState!
            .setUsername(SharedPreferencesUtilities.loginDetails!.username!);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          LoadingPage.backgroundDesign(),
          Center(
            child: Card(
              elevation: 15,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: ThemeUtilities.themes.colorGradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: GestureDetector(
                  onTap: removeAllFocus,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 1.1,
                    width: MediaQuery.of(context).size.width / 1.1,
                    child: buildColumn(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildColumn() => Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                iconPicture(),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Grader",
                  style: TextStyle(color: Colors.black, fontSize: 27),
                ),
                const SizedBox(
                  height: 15,
                ),
                SchoolTextField(
                  schools: widget.schools,
                  onSelected: () => setState(() {}),
                  key: keySchools,
                ),
                UsernameTextField(
                  enable: enable(),
                  key: keyUsername,
                  onChanged: () {
                    setState(() {});
                  },
                ),
                PasswordTextField(
                  enable: enable(),
                  isPassword: isPassword,
                  key: keyPassword,
                  onChanged: () {
                    setState(() {});
                  },
                ),
                buildBottom(),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          launchUrl(Uri.parse('https://web.mashov.info/students/recover'));
                        },
                        child: const Text(
                          'שכחת סיסמא?',
                          style: TextStyle(color: Colors.black87),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      );

  Widget iconPicture() => Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2, left: 4),
            child: Image.asset(
              'assets/real_Icon.png',
              height: 110,
              width: 110,
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          Image.asset(
            'assets/real_Icon.png',
            height: 110,
            width: 110,
          ),
        ],
      );

  bool enable() => keySchools.currentState == null
      ? false
      : keySchools.currentState!.selectedSchool == null
          ? false
          : true;

  Widget buildBottom() => BottomButtons(
        isPassword: isPassword,
        canRemember: !isKeyAvailable(keyPassword)
            ? true
            : keyPassword.currentState!.hintPasswordNew == null,
        changeIsPassword: () => setState(() {
          isPassword = !isPassword;
          keyPassword.currentState!.hintPasswordNew = null;
          keyPassword.currentState!.textEditingControllerPassWord.text = '';
          keyPassword.currentState!.focusNode.unfocus();
        }),
        loginDetails: LoginDetails(
          school: isKeyAvailable(keySchools)
              ? keySchools.currentState!.selectedSchool
              : null,
          year:
              isKeyAvailable(keySchools) ? keySchools.currentState!.year : null,
          username: isKeyAvailable(keyUsername)
              ? keyUsername.currentState!.textControllerUsername.text == ''
                  ? null
                  : keyUsername.currentState!.textControllerUsername.text
              : null,
          password: isKeyAvailable(keyPassword)
              ? keyPassword.currentState!.textEditingControllerPassWord.text ==
                      ''
                  ? null
                  : keyPassword.currentState!.textEditingControllerPassWord.text
              : null,
        ),
        receiveCode: () async {
          InformationDialog().showWithAnimation(context);
          keyPassword.currentState!.hintPasswordNew =
              'יש להקליד כאן את 6 הספרות שקיבלת במסרון';
          keyPassword.currentState!.textEditingControllerPassWord.text = '';
          keyPassword.currentState!.focusNode.unfocus();
          keyPassword.currentState!.visiblePassword = true;
          isPassword = !isPassword;
          setState(() {});
        },
      );

  bool isKeyAvailable(GlobalKey key) => key.currentState != null;

  void removeAllFocus() {
    if (isKeyAvailable(keySchools)) {
      keySchools.currentState!.focusNode.unfocus();
    }
    if (isKeyAvailable(keyUsername)) {
      keyUsername.currentState!.focusNode.unfocus();
    }
    if (isKeyAvailable(keyPassword)) {
      keyPassword.currentState!.focusNode.unfocus();
    }
  }
}
