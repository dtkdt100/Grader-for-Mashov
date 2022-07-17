import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:grader_for_mashov_new/main.dart';
import '../../../../utilities/phone/theme_utilities.dart';
import '../../widgets/custom_dialog/bottom_dialogs/bottom_flash_dialog.dart';
import 'login_page.dart';
import '../home_page/home_page.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/already_log_in_dialog.dart';
import '../../../../utilities/cloud/mashov_utilities.dart';
import '../../../../utilities/app/navigator_utilities.dart';
import '../../../../utilities/phone/shared_preferences_utilities.dart';

class LoadingPage extends StatefulWidget {
  final Future<void> Function()? doBefore;

  const LoadingPage({Key? key, this.doBefore}) : super(key: key);

  static Widget backgroundDesign() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: ThemeUtilities.themes.colorGradient,
        ),
      ),
    );
  }

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>  {
  bool doneLoadMemo = false;
  Themes themes = ThemeUtilities.themes;
  List<School> schools = [];

  @override
  void initState() {
    loadMemo();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          LoadingPage.backgroundDesign(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorFiltered(
                  colorFilter:
                      ColorFilter.mode(themes.colorPicture, BlendMode.color),
                  child: Image.asset(
                    'assets/real_Icon.png',
                    scale: 2.0,
                  ),
                ),
                doneLoadMemo
                    ? const SizedBox(
                        height: 35,
                      )
                    : const SizedBox(),
                doneLoadMemo
                    ? const SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 10,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadMemo() async {
    if (widget.doBefore != null) await widget.doBefore!();
    await SharedPreferencesUtilities.initSharedPrefs();
    SharedPreferencesUtilities.getAll();
    await Future.delayed(const Duration(milliseconds: 200));

    if (SharedPreferencesUtilities.alreadyLogin) {
      await AlreadyLogInDialog().showWithAnimation(context);
      await SharedPreferencesUtilities.clearAllPreferences();
      SharedPreferencesUtilities.getAll();
    }

    setState(() {
      doneLoadMemo = true;
    });

    if (SharedPreferencesUtilities.loginDetails == null) {
      loadSchools();
    } else {
      bool success =
          await MashovUtilities.login(SharedPreferencesUtilities.loginDetails!);
      if (success) {
        NavigatorUtilities(const HomePage())
            .pushReplacementWithNoAnimation(context);
      } else {
        BottomFlashDialog.show(context);
        loadSchools();
      }
    }
  }

  Future<void> loadSchools() async {
    ApiController controller = MashovApi.getController()!;
    schools = (await controller.getSchools()).value!;
    setState(() {});
    NavigatorUtilities(LoginPage(
      schools: schools,
    )).pushReplacementWithNoAnimation(context);
  }
}
