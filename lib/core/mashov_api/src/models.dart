import 'dart:convert';

import 'utils.dart';

///A result wrapper
class Result<E> {
  dynamic exception;
  E? value;
  int? _statusCode;

  int? get statusCode => _statusCode;

  Result({this.exception, this.value, int? statusCode}) {
    _statusCode = statusCode;
  }

  //Returns true if value can be used, false otherwise.
  bool get isSuccess => exception == null && value != null && isOk;

  bool get isUnauthorized => statusCode == 401;

  bool get isInternalServerError => statusCode == 500;

  bool get isNeedToLogin => isUnauthorized || isInternalServerError;

  bool get isForbidden => statusCode == 403;

  bool get isOk => statusCode == 200;
}

//login

class School {
  int id;
  String name;
  List<int> years;

  String getYears() => Utils.listToString(years);

  School({required this.id, required this.name, required this.years});

  static School fromJson(Map<String, dynamic> json) => School(
      id: json['semel'], name: json['name'], years: json['years'].cast<int>());

  static List<School> listFromJson(String src) =>
      (json.decode(src) as List)
      .map((school) => School.fromJson(school))
      .toList();

  Map<String, dynamic> toJson() => {'semel': id, 'name': name, 'years': years};
}

class Student {
  Student({
    required this.id,
    required this.familyName,
    required this.privateName,
    required this.classCode,
    required this.classNum
  });

  String id, familyName, privateName;
  String? classCode;
  int? classNum;

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
        id: json['childGuid'],
        familyName: json['familyName'],
        privateName: json['privateName'],
        classCode: json['classCode'],
        classNum: json['classNum']
    );
  }


  Map<String, dynamic> toJson() => {
    'childGuid': id,
    'familyName': familyName,
    'privateName': privateName,
    'classCode': classCode,
    'classNum': classNum
  };

  @override
  String toString() =>
      "Student(id=$id,privateName=\"$privateName\",familyName=\"$familyName\"";
}

class LoginData {
  LoginData(
      {required this.sessionId,
        required this.userId,
        required this.id,
        required this.userType,
        required this.schoolUserType,
        required this.schoolId,
        required this.year,
        required this.correlationId,
        required this.uniqueId});

  String sessionId, userId, id, correlationId, uniqueId;
  int userType, schoolUserType, schoolId, year;

  factory LoginData.fromJson(Map<String, dynamic> json, String uniqueId) => LoginData(
      sessionId: '',
      userId: json['userId'],
      id: "${json['idNumber']}",
      userType: json['userType'],
      schoolUserType: json['schoolUserType'],
      schoolId: json['semel'],
      year: json['year'],
      correlationId: json['correlationId'],
      uniqueId: uniqueId);

  Map<String, dynamic> toJson() => {
    'sessionId': '',
    'userId': userId,
    'id': id,
    'userType': userType,
    'schoolUserType': schoolUserType,
    'schoolId': schoolId,
    'year': year,
    'correlationId': correlationId,
    'uniquId' : uniqueId
  };
}

class Login {
  Login({required this.data, required this.students});

  LoginData data;
  List<Student> students;

  factory Login.fromJson(Map<String, dynamic> src, String uniqueId) {
    var credential = src["credential"];
    var token = src["accessToken"];
    if (token != null) {
      List<dynamic> children = token["children"];

      LoginData data = LoginData.fromJson(credential, uniqueId);
      List<Student> st = children.map((student) {
        return Student.fromJson(student as Map<String, dynamic>);
      }).toList();
      return Login(data: data, students: st);
    } else {
      throw Exception("token is null");
    }
  }

  static listToStringsList(List list) {
    List<String> strings = [];
    for (int i = 0; i < list.length; i++) {
      strings.add(list[i].toString());
    }
  }
}

//end login

//messages

class Attachment {
  String? id, name;

  Attachment({this.id, this.name});

  static Attachment fromJson(Map<String, dynamic> src) => Attachment(
      id: Utils.string(src["fileId"]), name: Utils.string(src["fileName"]));

  @override
  String toString() => super.toString() + " => { $id, $name }";
}

class MessageTitle {
  String messageId, subject, senderName;
  DateTime sendDate;
  bool isNew, hasAttachment;

  MessageTitle(
      { required this.messageId,
        required this.subject,
        required this.senderName,
        required this.sendDate,
        required this.isNew,
        required this.hasAttachment});

  static MessageTitle fromJson(Map<String, dynamic> src) => MessageTitle(
      messageId: Utils.string(src["messageId"]),
      subject: Utils.string(src["subject"]),
      senderName: Utils.string(src["senderName"]),
      sendDate: DateTime.parse(src["sendTime"]),
      isNew: Utils.boolean(src["isNew"]),
      hasAttachment: Utils.boolean(src["hasAttachments"]));

//  String toJson() {
//    return """{
//    "messageId": "$messageId",
//    "subject": "$subject",
//    "senderName": "$senderName",
//    "sendTime": "${sendDate.toIso8601String().split(".").first}",
//    "isNew": $isNew,
//    "hasAttachments": $hasAttachment
//    }""";
//  }

  @override
  String toString() {
    return super.toString() +
        " => { $messageId, $subject, $senderName, ${sendDate
            .toIso8601String()
            .split(".")
            .first}, $isNew, $hasAttachment";
  }
}

class Message {
  ///data class Message(
  /// val messageId: String, val sendDate: Long, val subject: String,
  /// val body: String, val sender: String, val attachments: List<Attachment>)
  String messageId, subject, sender, body;
  DateTime sendDate;
  List<Attachment> attachments;

  Message(
      {required this.messageId,
        required this.sendDate,
        required this.subject,
        required this.body,
        required this.sender,
        required this.attachments});

  static Message fromJson(Map<String, dynamic> src) {
    return Message(
        messageId: Utils.string(src["messageId"]),
        sendDate: DateTime.parse(src["sendTime"]),
        subject: Utils.string(src["subject"]),
        body: Utils.string(src["body"]),
        sender: Utils.string(src["senderName"]),
        attachments: Utils.attachments(src["files"]));
  }

  @override
  String toString() {
    return super.toString() +
        " => { $messageId, $subject, $sender, ${sendDate.toIso8601String()}, ${attachments.length} attachments";
  }
}

///Basically the parent of a Message.
class Conversation {
  String conversationId, subject;
  DateTime? sendTime;
  List<MessageTitle> messages;
  bool preventReply, isNew, hasAttachments;

  Conversation(
      {required this.conversationId,
        required this.subject,
        this.sendTime,
        required this.messages,
        required this.preventReply,
        required this.isNew,
        required this.hasAttachments});

  static Conversation fromJson(Map<String, dynamic> src) => Conversation(
      conversationId: Utils.string(src["conversationId"]),
      subject: Utils.string(src["subject"]),
      hasAttachments: Utils.boolean(src["hasAttachments"]),
      isNew: Utils.boolean(src["isNew"]),
      messages: src["messages"]
          .map<MessageTitle>((m) => MessageTitle.fromJson(m))
          .toList(),
      preventReply: Utils.boolean(src["preventReply"]));
}

class MessagesCount {
  int allMessages, inboxMessages, newMessages, unreadMessages;

  MessagesCount(
      {required this.allMessages,
        required this.inboxMessages,
        required this.newMessages,
        required this.unreadMessages});

  static MessagesCount fromJson(Map<String, dynamic> src) => MessagesCount(
      allMessages: Utils.integer(src["allMessages"]),
      inboxMessages: Utils.integer(src["inboxMessages"]),
      newMessages: Utils.integer(src["newMessages"]),
      unreadMessages: Utils.integer(src["unreadMessages"]));

  @override
  String toString() {
    return super.toString() +
        "{ $allMessages, $inboxMessages, $newMessages, $unreadMessages }";
  }
}

//end messages

//everything else
class Bagrut {
  String semel, name, moed, date, room, examStartTime, examEndTime;
  int finalGrade, yearGrade, testGrade;

  Bagrut(
      {required this.semel,
        required this.name,
        required this.date,
        required this.moed,
        required this.examStartTime,
        required this.examEndTime,
        required this.room,
        required this.finalGrade,
        required this.yearGrade,
        required this.testGrade});

  String stringify() => """{
  semel:      $semel,
  name:       $name,
  date:       $date,
  moed:       $moed,
  room:       $room,
  finalGrade: $finalGrade,
  yearGrade:  $yearGrade,
  testGrade:  $testGrade,
  times:      $examStartTime-$examEndTime,

  }""";

  static Bagrut fromJson(Map<dynamic, dynamic> src) =>
      Bagrut(
          semel: Utils.string(src["semel"]),
      name: Utils.string(src["name"]),
          date: Utils.string(src["examDate"]),
          moed: Utils.string(src["moed"]),
          room: Utils.string(src["examRoomNumber"]),
          examStartTime: Utils.string(src["examStartTime"]),
          examEndTime: Utils.string(src["examEndTime"]),
          finalGrade: Utils.integer(src["final"]),
          yearGrade: Utils.integer(src["shnaty"]),
          testGrade: Utils.integer(src["test"]));
}

class BehaveEvent {
  int groupId, lesson, type, justificationId;
  String text, justification, reporter, subject;
  DateTime date;

  BehaveEvent(
      {required this.groupId,
        required this.lesson,
        required this.date,
        required this.type,
        required this.text,
        required this.justificationId,
        required this.justification,
        required this.reporter,
        required this.subject});

  static BehaveEvent fromJson(Map<String, dynamic> src) => BehaveEvent(
      groupId: Utils.integer(src["groupId"]),
      lesson: Utils.integer(src["lesson"]),
      date: DateTime.parse(src["lessonDate"]),
      type: Utils.integer(src["lessonType"]),
      text: Utils.string(src["achvaName"]),
      justificationId: Utils.integer(src["justificationId"]),
      justification: Utils.string(src["justification"]),
      reporter: Utils.string(src["reporter"]),
      subject: Utils.string(src["subject"]));

  @override
  String toString() {
    return super.toString() +
        " => {$groupId, $lesson, ${date.toIso8601String()}, $type, $text, $justificationId, $justification, $reporter, $subject";
  }
}

class Lesson {
  int groupId, day, lesson;
  String subject, room, startTime, endTime;
  List<String> teachers;

  Lesson(
      {required this.groupId,
        required this.day,
        required this.lesson,
        required this.startTime,
        required this.endTime,
        required this.subject,
        required this.teachers,
        required this.room,});

  static Lesson fromJson(Map<dynamic, dynamic> src) {
    var tableData = src["timeTable"];
    var details = src["groupDetails"];
    bool tableDataNull = tableData == null;
    bool detailsNull = details == null;
    return Lesson(
        groupId: Utils.integer(tableDataNull ? null : tableData["groupId"]),
        day: Utils.integer(tableDataNull ? null : tableData["day"]),
        lesson: Utils.integer(tableDataNull ? null : tableData["lesson"]),
        startTime: Utils.string(src["startTime"]),
        endTime: Utils.string(src["endTime"]),
        subject: Utils.string(detailsNull ? null : details["subjectName"]),
        teachers: detailsNull
            ? null
            : details["groupTeachers"]
            .map<String>((t) => "${t["teacherName"]}")
            .toList(),
        room: Utils.string(tableDataNull ? null : tableData["roomNum"]));
  }

  @override
  String toString() =>
      super.toString() +
          " => { $groupId, $day, $lesson,$startTime-$endTime,$subject, ${teachers
              .join(", ")}, $room }";
}

class LessonCount {
  int groupId, lessonsCount, weeklyHours;

  LessonCount({
    required this.groupId,
    required this.lessonsCount,
    required this.weeklyHours
  });

  static LessonCount fromJson(Map<String, dynamic> src) => LessonCount(
    groupId: Utils.integer(src["groupId"]),
    lessonsCount: Utils.integer(src["lessonsCount"]),
    weeklyHours: Utils.integer(src["weeklyHours"]),
  );

  @override
  String toString() {
    return super.toString() +
        " => {$groupId, $lessonsCount, $weeklyHours";
  }
}

class BehaveCounter {
  String subject;
  int lessonsCount, weeklyHours, totalEvents;
  List<ShortBehaveEvent> events;

  BehaveCounter({
    required this.totalEvents,
    required this.subject,
    required this.weeklyHours,
    required this.lessonsCount,
    required this.events
  });
}

class ShortBehaveEvent {
  String subject, justification;
  int justificationId;

  ShortBehaveEvent({
    required this.subject,
    required this.justification,
    required this.justificationId
  });
}

class Grade {
  String teacher, subject, event;
  DateTime eventDate;
  int groupId, type, grade;

  Grade(
      {required this.teacher,
        required this.groupId,
        required this.subject,
        required this.eventDate,
        required this.event,
        required this.type,
        required this.grade});

  static Grade fromJson(Map<String, dynamic> src) {
    return Grade(
        teacher: Utils.string(src["teacherName"]),
        groupId: Utils.integer(src["groupId"]),
        subject: Utils.string(src["subjectName"]),
        eventDate: DateTime.parse(src["eventDate"]),
        event: Utils.string(src["gradingEvent"]),
        type: Utils.integer(src["gradeTypeId"]),
        grade: Utils.integer(src["grade"]));
  }

  static List<Grade> fromJsonArray(List<dynamic> src) =>
      src.map((g) => fromJson(g)).toList();

  @override
  String toString() {
    return super.toString() +
        "-> { teacher: $teacher, groupId: $groupId, subject: $subject, eventDate: ${eventDate.toIso8601String()}(${eventDate.millisecondsSinceEpoch}), event: $event, type: $type, grade: $grade }";
  }
}

class Group {
  int id;
  String subject;
  List<String>? teachers;

  Group({required this.id, required this.subject, this.teachers}) {
    teachers ??= [];
  }

  static Group fromJson(Map<String, dynamic> src) {
    return Group(
      id: Utils.integer(src["groupId"]),
      subject: Utils.string(src["subjectName"]).replaceAll("''", "\""),
      teachers: src["groupTeachers"]
          .map<String>((t) => "${t["teacherName"]}")
          .toList(),
    );
  }

  @override
  String toString() =>
      super.toString() +
          " => { id: $id, $subject" +
          (teachers!.isNotEmpty ? " - [${teachers!.join(", ",)}]" : "") +
          " }";

}

class Contact {
  String name, parentClass, address, phone;

  Contact({required this.name, required this.parentClass, required this.address, required this.phone});

  static Contact fromJson(Map<String, dynamic> src) {
    var city = Utils.string(src["city"]);
    var street = Utils.string(src["address"]);
    return Contact(
        name: Utils.string(src["privateName"]) +
            " " +
            Utils.string(src["familyName"]),
        phone: Utils.string(src["cellphone"]),
        parentClass: Utils.string(src["classCode"]) +
            Utils.integer(src["classNum"]).toString(),
        address: street +
            (city.isEmpty ? "" : (street.isEmpty ? city : ", " + city)));
  }

  @override
  String toString() =>
      super.toString() + " => { $name, $parentClass, $address, $phone }";
}

class Hatama {
  int code;
  String name, remark;

  Hatama({required this.code, required this.name, required this.remark});

  static Hatama fromJson(Map<String, dynamic> src) =>
      Hatama(
          code: Utils.integer(src["code"]),
          name: Utils.string(src["name"]),
          remark: Utils.string(src["remark"]));
}

class HatamatBagrut {
  String hatama, moed, name, semel;

  HatamatBagrut({required this.hatama, required this.moed, required this.name, required this.semel});

  static HatamatBagrut fromJson(Map<String, dynamic> src) =>
      HatamatBagrut(
          hatama: Utils.string(src["hatama"]),
          moed: Utils.string(src["moed"]),
          name: Utils.string(src["name"]),
          semel: Utils.string(src["semel"]));
}

class Homework {
  String message, subject;
  DateTime date;

  Homework({required this.message, required this.subject, required this.date});

  static Homework fromJson(Map<String, dynamic> src) => Homework(
      message: Utils.string(src["homework"]),
      date: DateTime.parse(src["lessonDate"]),
      subject: Utils.string(src["subjectName"]));
}

class Maakav {
  DateTime date;
  String message, reporter, id;
  List<Attachment> attachments;

  Maakav({required this.id, required this.date, required this.message, required this.reporter, required this.attachments});

  static Maakav fromJson(Map<String, dynamic> src) => Maakav(
      id: Utils.integer(src["maakavId"]).toString(),
      date: DateTime.parse(src["maakavDate"]),
      message: Utils.string(src["message"]),
      reporter: Utils.string(src["reporterName"]),
      attachments: Utils.attachments(src["filesMetadata"]));
}
