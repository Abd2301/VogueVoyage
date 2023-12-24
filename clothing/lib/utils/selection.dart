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
    required String name,
    required int? age,
    required String gender,
    required String bodyTypeOption,
    required String skinColorOption,
  }) {
    this.name = name;
    this.age = age!;
    this.gender = gender;
    this.bodyTypeOption = bodyTypeOption;
    this.skinColorOption = skinColorOption;
    notifyListeners(); // Notify listeners to rebuild widgets listening to this model.
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'bodyTypeOption': bodyTypeOption,
      'skinColorOption': skinColorOption,
    };
  }

}
