import 'cookie_manager.dart';

class CookieManagerImpl implements CookieManager {

  @override
  void clearAll() {
    _csrfToken = "";
    _mashovSessionId = "";
    _uniqueId = "";
    _listeners = {};
  }

  String _csrfToken = "";

  @override
  String get csrfToken => _csrfToken;

  @override
  set csrfToken(String csrfToken) {
    _csrfToken = csrfToken;
    trigger();
  }

  String _mashovSessionId = "";

  @override
  String get mashovAuthToken => _mashovSessionId;

  @override
  set mashovAuthToken(String mashovSessionId) {
    _mashovSessionId = mashovSessionId;
    trigger();
  }

  String _uniqueId = "";

  @override
  String get uniqueId => _uniqueId;

  @override
  set uniqueId(String uniqueId) {
    _uniqueId = uniqueId;
    trigger();
  }

  Map<int, Function> _listeners = {};

  @override
  void attachListener(int id, Function listener) {
    _listeners[id] = listener;
  }

  @override
  void detachListener(int id) {
    _listeners.remove(id);
  }

  @override
  void processHeaders(Map<String, List<String>> headers) {
    if (csrfToken.isNotEmpty &&
        mashovAuthToken.isNotEmpty &&
        uniqueId.isNotEmpty) {
      return;
    }
    var cToken = headers["x-csrf-token"];
    if (cToken != null) {
      csrfToken = cToken[0];
    }
    if (headers.containsKey("set-cookie")) {
      var cookie = headers["set-cookie"];

      uniqueId = cookie
          !.firstWhere((header) => header.contains("uniquId"))
          .split("=")
          .last;
      mashovAuthToken = cookie
          .firstWhere((header) => header.contains("MashovAuthToken"))
          .split("=")
          .last;
    }
  }

  void trigger() => _listeners.values.forEach((f) => f());
}
