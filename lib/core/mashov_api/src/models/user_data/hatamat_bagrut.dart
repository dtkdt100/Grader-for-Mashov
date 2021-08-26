import '../../utils.dart';

class HatamatBagrut {
  String hatama, moed, name, semel;

  HatamatBagrut({required this.hatama, required this.moed, required this.name, required this.semel});

  static HatamatBagrut fromJson(Map<String, dynamic> src) =>
      HatamatBagrut(
          hatama: Utils.string(src["hatama"]),
          moed: Utils.string(src["moed"]),
          name: Utils.string(src["name"]),
          semel: Utils.string(src["semel"]));
}