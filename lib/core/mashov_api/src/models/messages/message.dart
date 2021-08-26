import '../../utils.dart';
import 'attachment.dart';

class Message {
  ///data class Message(
  /// val messageId: String, val sendDate: Long, val subject: String,
  /// val body: String, val sender: String, val attachments: List<Attachment>)
  String messageId, subject, sender, body;
  DateTime sendDate;
  List<Attachment> attachments;

  Message(
      {required this.messageId,
        required this.sendDate,
        required this.subject,
        required this.body,
        required this.sender,
        required this.attachments});

  static Message fromJson(Map<String, dynamic> src) {
    return Message(
        messageId: Utils.string(src["messageId"]),
        sendDate: DateTime.parse(src["sendTime"]),
        subject: Utils.string(src["subject"]),
        body: Utils.string(src["body"]),
        sender: Utils.string(src["senderName"]),
        attachments: Utils.attachments(src["files"]));
  }

  @override
  String toString() {
    return super.toString() +
        " => { $messageId, $subject, $sender, ${sendDate.toIso8601String()}, ${attachments.length} attachments";
  }
}