import '../../utils.dart';
import 'message_title.dart';

class Conversation {
  String conversationId, subject;
  DateTime? sendTime;
  List<MessageTitle> messages;
  bool preventReply, isNew, hasAttachments;

  Conversation(
      {required this.conversationId,
        required this.subject,
        this.sendTime,
        required this.messages,
        required this.preventReply,
        required this.isNew,
        required this.hasAttachments});

  static Conversation fromJson(Map<String, dynamic> src) => Conversation(
      conversationId: Utils.string(src["conversationId"]),
      subject: Utils.string(src["subject"]),
      hasAttachments: Utils.boolean(src["hasAttachments"]),
      isNew: Utils.boolean(src["isNew"]),
      messages: src["messages"]
          .map<MessageTitle>((m) => MessageTitle.fromJson(m))
          .toList(),
      preventReply: Utils.boolean(src["preventReply"]));
}