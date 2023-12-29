import 'package:flutter/foundation.dart';

class SelectionModel with ChangeNotifier {
  String name;
  int age;
  String gender;
  String bodyTypeOption;
  String skinColorOption;

  SelectionModel({
    this.name = '',
    this.age = 0,
    this.gender = '',
    this.bodyTypeOption = '',
    this.skinColorOption = '',
  });

  void updateUserInfo({
  String? name,
  int? age,
  String? gender,
  String? bodyTypeOption,
  String? skinColorOption,
}) {
  if (name != null) this.name = name;
  if (age != null) this.age = age;
  if (gender != null) this.gender = gender;
  if (bodyTypeOption != null) this.bodyTypeOption = bodyTypeOption;
  if (skinColorOption != null) this.skinColorOption = skinColorOption;
  notifyListeners();
}

}
