import 'package:grader_for_mashov_new/core/mashov_api/src/models.dart';

class LoginDetails {
  School? school;
  String? username;
  String? password;
  int? year;
  String? uniqueId;

  LoginDetails({
    this.school,
    this.username,
    this.password,
    this.year,
    this.uniqueId,
  });

  Map<String, dynamic> toJson() => {
    'school': school,
    'username': username,
    'password': password,
    'year': year,
    'uniqueId': uniqueId,
  };

  bool isAllNotNull() {
    if (username == null) return false;
    if (password == null) return false;
    if (school == null) return false;
    if (year == null) return false;
    return true;
  }

  static LoginDetails fromJson(Map<String, dynamic> map) => LoginDetails(
    school: School.fromJson(map['school']),
    username: map['username'],
    password: map['password'],
    year:  map['year'],
    uniqueId: map['uniqueId']
  );

  @override
  String toString() {
    return 'LoginData{school: $school, username: $username, password: $password, year: $year, uniqueId: $uniqueId}';
  }
}