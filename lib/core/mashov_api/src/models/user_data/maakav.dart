import 'package:grader_for_mashov_new/core/mashov_api/src/models/messages/attachment.dart';

import '../../utils.dart';

class Maakav {
  DateTime date;
  String message, reporter, id;
  List<Attachment> attachments;

  Maakav({required this.id, required this.date, required this.message, required this.reporter, required this.attachments});

  static Maakav fromJson(Map<String, dynamic> src) => Maakav(
      id: Utils.integer(src["maakavId"]).toString(),
      date: DateTime.parse(src["maakavDate"]),
      message: Utils.string(src["message"]),
      reporter: Utils.string(src["reporterName"]),
      attachments: Utils.attachments(src["filesMetadata"]));
}