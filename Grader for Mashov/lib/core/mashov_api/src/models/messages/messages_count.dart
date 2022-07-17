import '../../utils.dart';

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