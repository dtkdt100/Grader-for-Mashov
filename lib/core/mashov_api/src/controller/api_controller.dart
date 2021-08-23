// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:grader_for_mashov_new/features/utilities/download_utilities.dart';
import 'package:http/http.dart' as http;
import 'cookie_manager.dart';
import 'request_controller.dart';
import '../models.dart';
import '../utils.dart';

typedef Parser<E> = E Function(Map<String, dynamic> src);
typedef DataProcessor = void Function(dynamic data, Api api);
typedef RawDataProcessor = void Function(String json, Api api);

//final Dio _dio = Dio();

class ApiController {
  final CookieManager _cookieManager;
  final RequestController _requestController;
  DataProcessor? _dataProcessor;
  RawDataProcessor? _rawDataProcessor;

  detachDataProcessor() {
    _dataProcessor = null;
  }

  attachDataProcessor(DataProcessor? processor) {
    if (processor != null) {
      _dataProcessor = processor;
    }
  }

  detachRawDataProcessor() {
    _rawDataProcessor = null;
  }

  attachRawDataProcessor(RawDataProcessor? processor) {
    if (processor != null) {
      _rawDataProcessor = processor;
    }
  }

  ApiController(CookieManager manager, RequestController controller) :
        _cookieManager = manager,
      _requestController = controller, _rawDataProcessor = null,
        _dataProcessor = null, jsonHeader = _setJsonHeader();


  ///returns a list of schools.
  Future<Result<List<School>>> getSchools() =>
      _authList(_schoolsUrl, School.fromJson, Api.Schools);

  ///Send one time password
  Future<bool> sendLoginCode(School school, String id, String cellphone) async {
    var body = {
      "cellphone": cellphone,
      "semel": school.id,
      "username": id,
    };
    Map<String, String> headers = {
      "Content-Type": "application/json"
    };
    var res = await _requestController.post(_cellphoneUrl, headers, json.encode(body));
    return res.statusCode == 200;
  }

  ///logs in to the Mashov API.
  Future<Login?> login(School school, String id, String password, int year,
      {String? uniqueId}) async {
    var body = {
      "semel": school.id,
      "username": id,
      "password": password,
      "year": year,
      "appName": "info.mashov.students",
      "appVersion": _ApiVersion,
      "apiVersion": _ApiVersion,
      "appBuild": _ApiVersion,
      "deviceUuid": "chrome",
      "devicePlatform": "chrome",
      "deviceManufacturer": "win",
      "deviceModel": "desktop",
      "deviceVersion": "85.0.4183.121"
    };

    Login? login;
    var headers = jsonHeader;

    headers.addAll(_loginHeader(uniqueId: uniqueId));
    await _requestController
        .post(_loginUrl, headers, json.encode(body))
        .then((response) {
      if (response.statusCode == 200) {
        String uniqueId =
            response.headers["set-cookie"]!.split("uniquId=").last.split(";")[0];
        processResponse(response);
        login = Login.fromJson(
            json.decode(utf8.decode(response.bodyBytes)), uniqueId);
      }
    });
    return login;
  }

  Future<List<dynamic>> getBells() async {
    Map<String, String> headers = _authHeader();
    List bellsMap =
        await _requestController.get(_bellsUrl, headers).then((response) {
      return json.decode(response.body);
    });
    return bellsMap;
  }

  ///Returns a list of grades.
  Future<Result<List<Grade>>> getGrades(String userId, {String? uniqueId}) async {
    Map<String, String> headers = _authHeader();
    if (uniqueId != null) {
      headers["uniquId"] = uniqueId;
    }
    var hi = await _requestController.get(_gradesUrl(userId), headers);
    var yo = _parseListResponse<Grade>(hi, Grade.fromJson, Api.Grades);
    return yo;
  }

  ///Returns a list of behave events.
  Future<Result<List<BehaveEvent>>>? getBehaveEvents(String userId) => _process(
      _authList<BehaveEvent>(
          _behaveUrl(userId), BehaveEvent.fromJson, Api.BehaveEvents),
      Api.BehaveEvents);

  ////Returns the messages count - all, inbox, new and unread.
  Future<Result<MessagesCount>> getMessagesCount() => _process(
          _auth(_messagesCountUrl, MessagesCount.fromJson, Api.MessagesCount),
          Api.MessagesCount)
      .then((r) => Result(
          exception: r.exception,
          statusCode: r.statusCode,
          value: r.value == null ? null : r.value as MessagesCount));

  ///Returns a list of conversations.
  Future<Result<List<Conversation>>> getMessages(int skip) => _process(
      _authList(_messagesUrl(skip), Conversation.fromJson, Api.Messages),
      Api.Messages);

  ///Returns a specific message.
  Future<Result<Message>> getMessage(String messageId) => _process(
          _auth(_messageUrl(messageId), Message.fromJson, Api.Message),
          Api.Message)
      .then((r) => Result(
          exception: r.exception,
          statusCode: r.statusCode,
          value: r.value == null ? null : r.value as Message));

  ///Returns the user timetable.
  Future<Result<List<List<Lesson>>>> getTimeTable(String userId) async {
//    try {
    Map<String, String> headers = _authHeader();

    List lessonsMap = await _requestController
        .get(_timetableUrl(userId), headers)
        .then((response) {
      List map;
      try {
        map = json.decode(response.body);
      } catch (e) {
        return [];
      }
      return map;
    });

    List bellsMap =
        await _requestController.get(_bellsUrl, headers).then((response) {
      return json.decode(response.body);
    });
    List maps = [];
    for (var l in lessonsMap) {
      int num = l["timeTable"]["lesson"];
      Map? matchingBell = bellsMap.firstWhere(
          (m) => Utils.integer(m["lessonNumber"]) == num,
          orElse: () => null);
      if (matchingBell == null) {
        print(
            "we've got a serious error here: no bell matched for lesson number $num, bells length is ${bellsMap.length}");
      }
      maps.add(matchingBell == null
          ? l
          : Utils.mergeMaps(l, {
              "startTime": matchingBell["startTime"],
              "endTime": matchingBell["endTime"]
            }));
    }
    List<Lesson> timetable = maps.map((m) => Lesson.fromJson(m)).toList();

    if (_dataProcessor != null) _dataProcessor!(timetable, Api.Timetable);
    return Result<List<List<Lesson>>>(
        exception: null, value: processTableTimeDate(timetable, bellsMap), statusCode: 200);
  }

  List<List<Lesson>> processTableTimeDate(List<Lesson> times, List<dynamic> bells){
    List<List<Lesson>> hi2 = [];

    for(int i = 0; i < 6; i++) {
      List<Lesson> hi = [];
      for (int j = 0; j < times.length; j++) {
        if (times[j].day == i+1){
          hi.add(times[j]);
        }
      }
      hi.sort((a, b) => a.lesson.compareTo(b.lesson));
      hi2.insert(0, hi);
    }

    for (int i = 0; i < hi2.length; i++) {
      List<Lesson> okTest = hi2[i];
      List jo = [];
      if (okTest.isNotEmpty) {
        for (int k = 1; k < (okTest.last.lesson) + 1; k++) {
          bool contains = false;
          for (int o = 0; o < okTest.length; o++) {
            if (okTest[o].lesson == k) {
              contains = true;
            }
          }
          if (!contains) {
            jo.add(k);
          }
        }
        for (int y = 0; y < jo.length; y++) {
          okTest.insert(jo[y], Lesson(subject: "!שיעור חופשי",
              lesson: jo[y],
              endTime: bells[jo[y] - 1]["endTime"],
              startTime: bells[jo[y] - 1]["startTime"],
              teachers: [""],
              room: "",
              groupId: 1,
              day: okTest.last.day));
        }
        okTest.sort((a, b) => a.lesson.compareTo(b.lesson));
      }
    }
    hi2.add([]);
    return hi2;
  }

  ///Returns a list of the Alfon Groups.
  ///The class group is a different address, so we use an id -1 to access it.
  Future<Result<List<Group>>> getGroups(String userId) async {
    Result<List<Group>> groups =
        await _authList<Group>(_groupsUrl(userId), Group.fromJson, Api.Groups);
    groups.value!.add(Group(id: -1, teachers: [], subject: "כיתת אם"));
    if (_dataProcessor != null) {
      _dataProcessor!(groups.value, Api.Groups);
    }
    return groups;
  }

  ///returns an Alfon Group contacts.
  Future<Result<List<Contact>>> getContacts(String userId, String groupId) =>
      _process(
          _authList(_alfonUrl(userId, groupId), Contact.fromJson, Api.Alfon),
          Api.Alfon);

  ///Returns a list of Maakav reports.
  Future<Result<List<Maakav>>> getMaakav(String userId) => _process(
      _authList(_maakavUrl(userId), Maakav.fromJson, Api.Maakav), Api.Maakav);

  ///Returns a list of homework.
  Future<Result<List<Homework>>> getHomework(String userId) => _process(
      _authList(_homeworkUrl(userId), Homework.fromJson, Api.Homework),
      Api.Homework);

  ///Returns a list of bagrut exams, combining both dates, times, room and grades.
  ///This will NOT go through raw data processor as it takes the data
  ///from two sources.
  Future<Result<List<Bagrut>>> getBagrut(String userId) async {
    try {
      Map<String, String> headers = _authHeader();
      List gradesMaps = await _requestController
          .get(_bagrutGradesUrl(userId), headers)
          .then((response) => json.decode(response.body));
      List timesMaps = await _requestController
          .get(_bagrutTimeUrl(userId), headers)
          .then((response) => json.decode(response.body));
      List<Map> maps = [];
      for (var g in gradesMaps) {
        int semel = Utils.integer(g["semel"]);
        Map? matchingTime = timesMaps.firstWhere(
            (m) => Utils.integer(m["semel"]) == semel,
            orElse: () => null);
        maps.add(matchingTime == null ? g : Utils.mergeMaps(g, matchingTime));
      }
      List<Bagrut> bagrut = maps.map((m) => Bagrut.fromJson(m)).toList();
      if (_dataProcessor != null) _dataProcessor!(bagrut, Api.Bagrut);
      return Result<List<Bagrut>>(
          exception: null, value: bagrut, statusCode: 200);
    } catch (e) {
      return Result(exception: e, value: null, statusCode: 200);
    }
  }

  //Returns the user's hatamot.
  Future<Result<List<Hatama>>> getHatamot(String userId) => _process(
      _authList(_hatamotUrl(userId), Hatama.fromJson, Api.Hatamot),
      Api.Hatamot);

  ///Returns the user's Hatamot bagrut.
  Future<Result<List<HatamatBagrut>>> getHatamotBagrut(String userId) =>
      _process(
          _authList(_hatamotBagrutUrl(userId), HatamatBagrut.fromJson,
              Api.HatamotBagrut),
          Api.HatamotBagrut);

  ///Return the lesson count
  Future<List<BehaveCounter>> getEventsCounter(String userId) async {
    Result<List<BehaveEvent>> behaves2 = await _process(
        _authList<BehaveEvent>(
            _behaveUrl(userId), BehaveEvent.fromJson, Api.BehaveEvents),
        Api.BehaveEvents);

    Result<List<Group>> groups2 =
        await _authList<Group>(_groupsUrl(userId), Group.fromJson, Api.Groups);


    Result<List<LessonCount>?> lessonCounts = await _authList(
        _lessonCountUrl(userId), LessonCount.fromJson, Api.LessonCount);
    List<BehaveEvent>? behaves = behaves2.value;
    List<Group>? groups = groups2.value;
    List<BehaveCounter> behaveCounter = [];

    if(groups == null) return [];

    for (int i = 0; i < groups.length; i++) {
      String sub = groups[i].subject;
      LessonCount lessonCount;
      int lessonsCount;
      int weeklyHours;
      List<ShortBehaveEvent> events = [];

      try {
        lessonCount = lessonCounts.value!
            .where((element) => element.groupId == groups[i].id)
            .first;
        lessonsCount = lessonCount.lessonsCount;
        weeklyHours = lessonCount.weeklyHours;
      } catch (e) {
        weeklyHours = 0;
        lessonsCount = 0;
      }

      var totalEvents =
          behaves!.where((element) => element.groupId == groups[i].id);

      if (totalEvents.isNotEmpty) {
        for (int j = 0; j < totalEvents.length; j++) {
          BehaveEvent behaveEvent = totalEvents.elementAt(j);
          events.add(ShortBehaveEvent(
            subject: behaveEvent.subject,
            justification: behaveEvent.justification,
            justificationId: behaveEvent.justificationId,
          ));
        }
      }

      behaveCounter.add(BehaveCounter(
          subject: sub,
          lessonsCount: lessonsCount,
          weeklyHours: weeklyHours,
          events: events,
          totalEvents: totalEvents.length));
    }

    return behaveCounter;
  }

  ///Returns the user profile picture into given file parameter.
  Future<File> getPicture(String userId, File file) {
    Map<String, String> headers = _authHeader();
    headers.addAll(_authHeader());
    return _requestController
        .get(_pictureUrl(userId), headers)
        .then((response) {
      return response.bodyBytes;
    }).then((picture) {
      return file.writeAsBytes(picture);
    });
  }

  ///log out from the session. might want to reset the cookies, but anyway
  ///The application should make sure these are reset.
  Future<void> logout() async {
    Map<String, String> headers = {
      "Cookie":
          "uniquId=${_cookieManager.uniqueId};MashovAuthToken=${_cookieManager.mashovAuthToken}",
    };
    headers.addAll(_authHeader());
    await _requestController.get(_logoutUrl, _authHeader());
    _requestController.changeClient();
    _cookieManager.clearAll();
  }

  Future<Map<String, dynamic>?> getAttachment(String messageId, String fileId, String name) async {

    Map<String, String> headers = _authHeader();
    headers.addAll(_authHeader());

    return await DownloadUtilities(
      link: _attachmentUrl(messageId, fileId, name),
      fileName: name,
      headers: headers
    ).startDownload();
  }


  ///Returns a given maakav attachment.
  Future<File> getMaakavAttachment(
      String maakavId, String userId, String fileId, String name, File file) {
    Map<String, String> headers = _authHeader();
    headers.addAll(_authHeader());
    return _requestController
        .get(_maakavAttachmentUrl(maakavId, userId, fileId, name), headers)
        .then((response) => response.bodyBytes)
        .then((attachment) => file.writeAsBytes(attachment));
  }

  ///Returns a list of E, using an authenticated request.
  Future<Result<List<E>>> _authList<E>(
      String url, Parser<E> parser, Api api) async {
    Map<String, String> headers = _authHeader();
    if (url != _schoolsUrl) {
      /// we don't need authentication when getting schools.
      headers.addAll(_authHeader());
    }
    return _requestController
        .get(url, headers)
        .then((response) => _parseListResponse(response, parser, api));
    //.then((body) => body.map<E>((e) => parser(e)).toList());
  }

  ///Returns E, using an authenticated request.
  Future<Result<E>> _auth<E>(String url, Parser parser, Api api) async {
    Map<String, String> headers = _authHeader();
    headers.addAll(_authHeader());
    return _requestController
        .get(url, headers)
        .then((response) => _parseResponse(response, parser, api));
  }

  Result<E> _parseResponse<E>(http.Response response, Parser parser, Api api) {
    try {
      Map<String, dynamic> src = json.decode(response.body);
      Result<E> result = Result(
          exception: null, value: parser(src), statusCode: response.statusCode);
      //if it had not crashed, we know the data is good.
      if (_rawDataProcessor != null) {
        _rawDataProcessor!(response.body, api);
      }
      return result;
    } catch (e) {
      return Result(exception: e, value: null, statusCode: response.statusCode);
    }
  }

  Result<List<E>> _parseListResponse<E>(
      http.Response response, Parser parser, Api api) {
    try {
      List src = json.decode(response.body);
      Result<List<E>> result = Result(
          exception: null,
          value: src.map<E>((e) => parser(e)).toList(),
          statusCode: response.statusCode);


      //if it had not crashed, we know the data is good.
      if (_rawDataProcessor != null) {
        _rawDataProcessor!(response.body, api);
      }
      return result;
    } catch (e) {
      return Result(exception: e, value: null, statusCode: response.statusCode);
    }
  }

  void processResponse(http.Response response) {
    _cookieManager.processHeaders(Utils.decodeHeaders(response.headers));
  }

  ///The authentication header.
  Map<String, String> _authHeader() {
    Map<String, String> headers = {}..addAll(jsonHeader);

    ///uniquId is NOT a typo!
    ///I...I really don't know why they named it that way.
    ///just... go on
    headers["cookie"] =
        "uniquId=${_cookieManager.uniqueId}; MashovAuthToken=${_cookieManager.mashovAuthToken}; Csrf-Token=${_cookieManager.csrfToken}";
    headers["x-csrf-token"] = _cookieManager.csrfToken;
    return headers;
  }

  Map<String, String> _loginHeader({uniqueId}) {
    Map<String, String> headers = {};
    headers["x-csrf-token"] = _cookieManager.csrfToken;
    headers["accept-encoding"] = "gzip";
    headers["Host"] = "web.mashov.info";
    if (uniqueId != null) {
      headers["Cookie"] = "uniquId=$uniqueId;";
    }
    return headers;
  }

  Map<String, String> jsonHeader;
  static const String _baseUrl = "https://web.mashov.info/api/";
  static const String _schoolsUrl = _baseUrl + "schools";
  static const String _loginUrl = _baseUrl + "login";
  static const String _messagesCountUrl = _baseUrl + "mail/counts";
  static const String _cellphoneUrl = _baseUrl + "user/otp";

  static String _gradesUrl(String userId) =>
      _baseUrl + "students/$userId/grades";

  static String _bagrutGradesUrl(String userId) =>
      _baseUrl + "students/$userId/bagrut/grades";

  static String _bagrutTimeUrl(String userId) =>
      _baseUrl + "students/$userId/bagrut/sheelonim";

  static String _hatamotUrl(String userId) =>
      _baseUrl + "students/$userId/hatamot";

  static String _hatamotBagrutUrl(String userId) =>
      _baseUrl + "students/$userId/bagrut/hatamot";

  static String _behaveUrl(String userId) =>
      _baseUrl + "students/$userId/behave";

  static String _messagesUrl(int skip) =>
      _baseUrl + "mail/inbox/conversations?skip=$skip";

  static String _messageUrl(String messageId) =>
      _baseUrl + "mail/messages/$messageId";

  static String _timetableUrl(String userId) =>
      _baseUrl + "students/$userId/timetable";

  static const String _bellsUrl = _baseUrl + "bells";

  static String _groupsUrl(String userId) =>
      _baseUrl + "students/$userId/groups";

  static String _maakavUrl(String userId) =>
      _baseUrl + "students/$userId/maakav";

  static String _homeworkUrl(String userId) =>
      _baseUrl + "students/$userId/homework";

  static String _pictureUrl(String userId) => _baseUrl + "user/$userId/picture";

  static String _attachmentUrl(String messageId, String fileId, String name) =>
      _baseUrl + "mail/messages/$messageId/files/$fileId/download/$name";

  static String _maakavAttachmentUrl(
          String maakavId, String userId, String fileId, String name) =>
      _baseUrl + "students/$userId/maakav/$maakavId/files/$fileId/$name";

  static String _lessonCountUrl(String userId) =>
      _baseUrl + "students/$userId/lessonsCount";

  static String _alfonUrl(String userId, String groupId) =>
      _baseUrl +
      (groupId == "-1" ? "students/$userId/alfon" : "groups/$groupId/alfon");

  static const String _logoutUrl = _baseUrl + "logout";

  static const String _ApiVersion = "3.20210425";

  static Map<String, String> _setJsonHeader() {
    Map<String, String> jsonHeader = {};
    jsonHeader["content-type"] = "application/json;charset=UTF-8";
    jsonHeader["accept"] = "application/json, text/plain, */*";
    jsonHeader["accept-language"] = "en-US,en;q=0.9;he;q=0.8";
    return jsonHeader;
  }

  Future<Result<E>> _process<E>(Future<Result<E>> data, Api api) {
    if (_dataProcessor != null) {
      if (data is Future<Result>) {
        data.then((result) {
          if (result.isSuccess) {
            _dataProcessor!(result.value, api);
          }
        });
      } else {
        print(
            "Api controller data proccessor recieved data which is not of type Future<Result>");
        _dataProcessor!(data, api);
      }
    }
    return data;
  }
}

enum Api {
  Schools,
  Login,
  Grades,
  Bagrut,
  BehaveEvents,
  Groups,
  Timetable,
  Alfon,
  Messages,
  Message,
  Details,
  MessagesCount,
  Maakav,
  Homework,
  Hatamot,
  HatamotBagrut,
  LessonCount
}
