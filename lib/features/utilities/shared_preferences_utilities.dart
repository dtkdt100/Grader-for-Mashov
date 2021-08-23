import 'dart:convert';
import 'dart:io';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';
import 'package:grader_for_mashov_new/features/data/themes/themes.dart';
import 'package:grader_for_mashov_new/features/models/home_page_data.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtilities {
  static Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  static const String _keyLoginData = 'loginData';
  static const String _keyPicture = 'Picture';
  static const String _keyThemeMode = 'mode';
  static const String _keyRemoveZeros = 'removeZeros';
  static const String _keyLeaderBoard = 'isLogInToLeaderBoard';

  static Themes themes = LightThemes();
  static String? filePath;
  static LoginDetails? loginDetails;
  static bool removeZeros = false;
  static bool connectedToLeaderBoard = false;
  static bool alreadyLogin = false;

  ///Get all
  static Future<void> getAll() async {
    await getLoginData();
    await getPicture();
    await getTheme();
    await getZero();
    await getLeaderBoard();
    await getAlreadyLogin();
  }

  ///Login data
  static Future<void> setLoginData(LoginDetails loginData) async {
    loginDetails = loginData;
    (await prefs).setString(_keyLoginData, _encode(loginData.toJson()));
  }

  static Future<LoginDetails?> getLoginData() async {
    String? loginDataString = (await prefs).getString(_keyLoginData);

    if (loginDataString == null) return null;

    loginDetails = LoginDetails.fromJson(_decode<dynamic>(loginDataString));
    return loginDetails;
  }

  ///Picture
  static Future<void> setPicture(String path) async {
    filePath = path;
    (await prefs).setString(_keyPicture, path);
  }

  static Future<File?> getPicture() async {
    String? path = (await prefs).getString(_keyPicture);

    if (path == null) return null;

    filePath = path;
    return File(path);
  }

  ///Zeros
  static Future<void> setZero(bool zero) async {
    removeZeros = zero;
    (await prefs).setBool(_keyRemoveZeros, zero);
  }

  static Future<bool?> getZero() async {
    bool? zero = (await prefs).getBool(_keyRemoveZeros);
    if (zero == null) return null;
    removeZeros = zero;
    return zero;
  }

  ///LeaderBoard
  static Future<void> setLeaderBoard(bool connected) async {
    connectedToLeaderBoard = connected;
    (await prefs).setBool(_keyLeaderBoard, connected);
  }

  static Future<bool?> getLeaderBoard() async {
    bool? connected = (await prefs).getBool(_keyLeaderBoard);

    if (connected == null) return null;

    connectedToLeaderBoard = connected;
    return connected;
  }

  ///Themes
  static Future<void> setTheme(String mode) async {
    themes = mode == 'dark' ? DarkThemes() : LightThemes();
    (await prefs).setString(_keyThemeMode, mode);
  }

  static Future<Themes?> getTheme() async {
    String? mode = (await prefs).getString(_keyThemeMode);

    if (mode == null) return null;

    themes = mode == 'dark' ? DarkThemes() : LightThemes();
    return themes;
  }

  ///Already login
  static Future<bool?> getAlreadyLogin() async {
    String? login = (await prefs).getString('Username');
    alreadyLogin = login != null;
    if (login == null) return false;
    return true;
  }

  ///Clear all - for tests
  static Future<void> clearAllPreferences() async {
    themes = LightThemes();
    filePath = null;
    loginDetails = null;
    removeZeros = false;
    connectedToLeaderBoard = false;
    MashovUtilities.loginData = null;
    MashovUtilities.homePageData = HomePageData(
        avg: '0',
        grades: null,
        hoursOfDay: '0',
        msgs: '0',
        tableTime: null,
        homeWorks: null);
    (await prefs).clear();
  }


  static String _encode(Map<String, dynamic> map) => json.encode(map);

  static Map<String, E> _decode<E>(String map) =>
      Map<String, E>.from(json.decode(map));

}