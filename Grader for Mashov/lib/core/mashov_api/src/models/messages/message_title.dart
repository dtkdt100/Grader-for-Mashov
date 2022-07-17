import '../../utils.dart';

class MessageTitle {
  String messageId, subject, senderName;
  DateTime sendDate;
  bool isNew, hasAttachment;

  MessageTitle(
      { required this.messageId,
        required this.subject,
        required this.senderName,
        required this.sendDate,
        required this.isNew,
        required this.hasAttachment});

  static MessageTitle fromJson(Map<String, dynamic> src) => MessageTitle(
      messageId: Utils.string(src["messageId"]),
      subject: Utils.string(src["subject"]),
      senderName: Utils.string(src["senderName"]),
      sendDate: DateTime.parse(src["sendTime"]),
      isNew: Utils.boolean(src["isNew"]),
      hasAttachment: Utils.boolean(src["hasAttachments"]));


  @override
  String toString() {
    return super.toString() +
        " => { $messageId, $subject, $senderName, ${sendDate
            .toIso8601String()
            .split(".")
            .first}, $isNew, $hasAttachment";
  }
}
