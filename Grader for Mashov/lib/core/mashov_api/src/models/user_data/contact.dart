import '../../utils.dart';

class Contact {
  String name, parentClass, address, phone;

  Contact({required this.name, required this.parentClass, required this.address, required this.phone});

  static Contact fromJson(Map<String, dynamic> src) {
    var city = Utils.string(src["city"]);
    var street = Utils.string(src["address"]);
    return Contact(
        name: Utils.string(src["privateName"]) +
            " " +
            Utils.string(src["familyName"]),
        phone: Utils.string(src["cellphone"]),
        parentClass: Utils.string(src["classCode"]) +
            Utils.integer(src["classNum"]).toString(),
        address: street +
            (city.isEmpty ? "" : (street.isEmpty ? city : ", " + city)));
  }

  @override
  String toString() =>
      super.toString() + " => { $name, $parentClass, $address, $phone }";
}