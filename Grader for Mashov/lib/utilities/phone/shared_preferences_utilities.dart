import 'dart:convert';
import 'dart:io';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_order_dialog.dart';
import 'package:grader_for_mashov_new/utilities/phone/theme_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cloud/mashov_utilities.dart';

export '../phone/theme_utilities.dart';

class SharedPreferencesUtilities {
  static late SharedPreferences prefs;

  static const String _keyLoginData = 'loginData';
  static const String _keyPicture = 'Picture';
  static const String _keyThemeMode = 'mode';
  static const String _keyRemoveZeros = 'removeZeros';
  static const String _keyRemoveInClass = 'removeIsClass';
  static const String _keyLeaderBoard = 'isLogInToLeaderBoard';
  static const String _keyHomePageCards = 'homePageCards';
  static const String _keyLastAvg = 'lastAvg';

  static String themeMode = themeDict[ThemeApp.light]!.toString();
  static String? filePath;
  static LoginDetails? loginDetails;
  static bool removeZeros = true;
  static bool removeInClass = false;
  static bool connectedToLeaderBoard = false;
  static bool alreadyLogin = false;
  static List<bool>? homePageCards;
  static double? lastAvg;

  ///Get all
  static void getAll() {
    getLoginData();
    getPicture();
    getTheme();
    getLastAvg();
    getZero();
    getInClass();
    getLeaderBoard();
    getAlreadyLogin();
    getHomePageCards();
  }

  static Future<void>   initSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<void> changeYear(int year) async {
    await prefs.remove(_keyLeaderBoard);
    await prefs.remove(_keyPicture);
    await prefs.remove(_keyThemeMode);
    loginDetails!.year = year;
    clearMostPreferences();
    await setLoginData(loginDetails!);
  }

  ///Login data
  static Future<void> setLoginData(LoginDetails loginData) async {
    loginDetails = loginData;
    await prefs.setString(_keyLoginData, _encode(loginData.toJson()));
  }

  static LoginDetails? getLoginData() {
    String? loginDataString = prefs.getString(_keyLoginData);
    if (loginDataString == null) return null;
    loginDetails = LoginDetails.fromJson(_decode<dynamic>(loginDataString));
    return loginDetails;
  }

  ///Picture
  static Future<void> setPicture(String path) async {
    filePath = path;
    await prefs.setString(_keyPicture, path);
  }

  static File? getPicture() {
    String? path = prefs.getString(_keyPicture);
    if (path == null) return null;
    filePath = path;
    return File(path);
  }

  ///Home page cards
  static Future<void> setHomePageCards(List<bool> cards) async {
    homePageCards = cards;
    await prefs.setString(_keyHomePageCards, _encode(cards));
  }

  static List<bool>? getHomePageCards() {
    String? cards = prefs.getString(_keyHomePageCards);
    if (cards == null) {
      homePageCards =
          List.generate(ChangeOrderDialog.cards.length, (index) => true);
      homePageCards![3] = false;
      return null;
    }
    homePageCards = _decodeList<bool>(cards);
    return homePageCards;
  }

  /// Zeros
  static Future<void> setZero(bool zero) async {
    removeZeros = zero;
    await prefs.setBool(_keyRemoveZeros, zero);
  }

  static bool? getZero() {
    bool? zero = prefs.getBool(_keyRemoveZeros);
    if (zero == null) return null;
    removeZeros = zero;
    return zero;
  }

  /// Remove נוכחות בשיעור
  static Future<void> setInClass(bool inClass) async {
    removeInClass = inClass;
    await prefs.setBool(_keyRemoveInClass, inClass);
  }

  static bool? getInClass() {
    bool? inClass = prefs.getBool(_keyRemoveInClass);
    if (inClass == null) return null;
    removeInClass = inClass;
    return inClass;
  }

  /// Last avg for sending to server
  static Future<void> setLastAvg(double avg) async {
    lastAvg = avg;
    await prefs.setDouble(_keyLastAvg, avg);
  }

  static double? getLastAvg() {
    double? avg = prefs.getDouble(_keyLastAvg);
    if (avg == null) return null;
    lastAvg = avg;
    return avg;
  }

  ///LeaderBoard
  static Future<void> setLeaderBoard(bool connected) async {
    connectedToLeaderBoard = connected;
    await prefs.setBool(_keyLeaderBoard, connected);
  }

  static bool? getLeaderBoard() {
    bool? connected = prefs.getBool(_keyLeaderBoard);

    if (connected == null) return null;

    connectedToLeaderBoard = connected;
    return connected;
  }

  ///Themes
  static Future<void> setTheme(String mode) async {
    themeMode = mode;
    await prefs.setString(_keyThemeMode, mode);
  }

  static Themes? getTheme() {
    String? mode = prefs.getString(_keyThemeMode);
    themeMode = themeDict[ThemeApp.light]!.toString();
    if (mode == null) return null;

    ThemeUtilities.setThemeString(mode);
    return ThemeUtilities.themes;
  }

  ///Already login
  static bool? getAlreadyLogin() {
    String? login = prefs.getString('Username');
    alreadyLogin = login != null;
    if (login == null) return false;
    return true;
  }

  ///Clear all
  static Future<void> clearAllPreferences() async {
    clearMostPreferences();
    loginDetails = null;
    await prefs.clear();
  }

  static void clearMostPreferences() {
    filePath = null;
    removeZeros = false;
    connectedToLeaderBoard = false;
    MashovUtilities.loginData = null;
    MashovUtilities.homePageData.clear();
  }

  static String _encode(Object value) => json.encode(value);

  static Map<String, E> _decode<E>(String map) =>
      Map<String, E>.from(json.decode(map));

  static List<E> _decodeList<E>(String list) => List<E>.from(json.decode(list));
}
