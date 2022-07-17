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