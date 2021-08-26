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