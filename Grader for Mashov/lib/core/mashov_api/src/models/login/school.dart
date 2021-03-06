import 'dart:convert';
import '../../utils.dart';

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
