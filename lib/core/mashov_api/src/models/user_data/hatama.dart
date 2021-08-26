import '../../utils.dart';

class Hatama {
  int code;
  String name, remark;

  Hatama({required this.code, required this.name, required this.remark});

  static Hatama fromJson(Map<String, dynamic> src) =>
      Hatama(
          code: Utils.integer(src["code"]),
          name: Utils.string(src["name"]),
          remark: Utils.string(src["remark"]));
}