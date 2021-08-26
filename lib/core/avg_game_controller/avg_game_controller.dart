import 'dart:async';
import 'dart:convert';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/login/login.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models/login/login_data.dart';

import '../mashov_api/src/controller/request_controller/request_controller.dart';
import '../mashov_api/src/controller/request_controller/request_controller_impl.dart';
import 'package:grader_for_mashov_new/features/data/login_details/login_details.dart';

class AvgGameController {
  final LoginData data;

  AvgGameController(this.data);

  final RequestController _requestController = RequestControllerImpl();

  static String _leaderBoardUrl(String ageGroup, String id) =>
      _baseUrl + "leaderBoard?id=$id&ageGroup=$ageGroup";

  ///Info
  Future<Map<String, dynamic>> getInfo() async =>
      await getParser(_infoUrl(data.userId));

  ///LeaderBoard
  Future<Map<String, dynamic>> getLeaderBoard(String ageGroup) async =>
      await getParser(_leaderBoardUrl(ageGroup, data.userId));

  ///Sign in the user OR adding ageGroup to the user
  Future<bool> signIn(
      String name, Login login, LoginDetails loginDetails, double avg) async {
    Map<String, dynamic> body = {
      "name": name,
      "school": loginDetails.school!.name,
      "id": data.userId,
      "ageGroup": fixAgeGroup(login.students[0].classCode!),
      "avg": avg.toString(),
    };
    return await postParser(_signInUrl, body);
  }

  ///Update the user's avg
  Future<bool> updateAvg(double avg, Login login) async {
    Map<String, dynamic> body = {
      "id": data.userId,
      "ageGroup": fixAgeGroup(login.students[0].classCode!),
      "avg": avg.toString()
    };
    return await postParser(_updateAvgUrl, body);
  }

  ///Update the user's name
  Future<bool> updateName(String name) async {
    Map<String, dynamic> body = {
      "id": data.userId,
      "name": name,
    };
    return await postParser(_updateNameUrl, body);
  }

  ///Delete the user from the server
  Future<bool> deleteUser() async =>
      postParser(_deleteUserUrl, {"id": data.userId});

  Future<Map<String, dynamic>> getParser(String url) async =>
      json.decode((await _requestController.get(url, {})).body);

  Future<bool> postParser(String url, Map<String, dynamic> body) async =>
      (await _requestController.post(url, {}, body)).statusCode == 200;

  //static const String _baseUrl = "http://10.0.2.2:5000/";
  static const String _baseUrl = "https://graderserver.herokuapp.com/";
  static const String _baseUrlApi = _baseUrl + "api/";

  static String _infoUrl(String id) => _baseUrl + "info?id=$id";
  static const String _signInUrl = _baseUrlApi + "login";
  static const String _deleteUserUrl = _baseUrlApi + "deleteUser";
  static const String _updateNameUrl = _baseUrlApi + "updateName";
  static const String _updateAvgUrl = _baseUrlApi + "updateAvg";

  static String fixAgeGroup(String ageGroup) {
    if (ageGroup == "יא") {
      ageGroup = 'י"א';
    } else if (ageGroup == "יב") {
      ageGroup = 'י"ב';
    }
    return ageGroup;
  }
}
