import 'dart:convert';
import 'dart:io';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/custom_dialog/dialogs/home_page_dialogs/change_order_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mashov_utilities.dart';

class SharedPreferencesUtilities {
  static late SharedPreferences prefs;

  static const String _keyLoginData = 'loginData';
  static const String _keyPicture = 'Picture';
  static const String _keyThemeMode = 'mode';
  static const String _keyRemoveZeros = 'removeZeros';
  static const String _keyLeaderBoard = 'isLogInToLeaderBoard';
  static const String _keyHomePageCards = 'homePageCards';

  static Themes themes = LightTheme();
  static String? filePath;
  static LoginDetails? loginDetails;
  static bool removeZeros = false;
  static bool connectedToLeaderBoard = false;
  static bool alreadyLogin = false;
  static List<bool>? homePageCards;

  ///Get all
  static void getAll() {
    getLoginData();
    getPicture();
    getTheme();
    getZero();
    getLeaderBoard();
    getAlreadyLogin();
    getHomePageCards();
  }

  static Future<void> initSharedPrefs() async {
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
      return null;
    }
    homePageCards = _decodeList<bool>(cards);
    return homePageCards;
  }

  ///Zeros
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
    themes = mode == 'dark' ? DarkTheme() : LightTheme();
    await prefs.setString(_keyThemeMode, mode);
  }

  static Themes? getTheme() {
    String? mode = prefs.getString(_keyThemeMode);

    if (mode == null) return null;

    themes = mode == 'dark' ? DarkTheme() : LightTheme();
    return themes;
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
    themes = LightTheme();
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
