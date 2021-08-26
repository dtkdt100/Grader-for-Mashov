abstract class CookieManager {

  late String csrfToken, mashovAuthToken, uniqueId;

  ///Saves the csrf-token, session id and uniqueId.
  void processHeaders(Map<String, List<String>> headers);

  ///Attach a listener to cookie manager - whenever one of the variables is updated, these listeners are triggered
  void attachListener(int id, Function listener);

  ///Detach a listener from the cookie manager.
  void detachListener(int id);

  ///Clear all data saved
  void clearAll();
}
