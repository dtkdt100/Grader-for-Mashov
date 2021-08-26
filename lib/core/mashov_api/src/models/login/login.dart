import 'login_data.dart';
import 'student.dart';

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