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