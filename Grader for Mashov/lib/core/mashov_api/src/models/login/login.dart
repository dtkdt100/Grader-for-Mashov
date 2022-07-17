import 'login_data.dart';
import 'student.dart';

class Login {
  Login({required this.data, required this.students, required this.userSchoolYears});

  LoginData data;
  List<Student> students;
  List<int> userSchoolYears;

  factory Login.fromJson(Map<String, dynamic> src, String uniqueId) {
    var credential = src["credential"];
    var token = src["accessToken"];
    if (token != null) {
      List<dynamic> children = token["children"];

      LoginData data = LoginData.fromJson(credential, uniqueId);
      List<Student> st = children.map((student) {
        return Student.fromJson(student as Map<String, dynamic>);
      }).toList();
      List<int> uSY = List<int>.from(token["userSchoolYears"]);
      return Login(data: data, students: st, userSchoolYears: uSY);
    } else {
      throw Exception("token is null");
    }
  }

  static List<String> listToStringsList(List list) {
    List<String> strings = [];
    for (int i = 0; i < list.length; i++) {
      strings.add(list[i].toString());
    }
    return strings;
  }

  @override
  String toString() {
    return 'Login{data: $data, students: $students, userSchoolYears: $userSchoolYears}';
  }
}