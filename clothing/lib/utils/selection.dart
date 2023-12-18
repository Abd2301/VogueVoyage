import 'package:flutter/foundation.dart'; // Add this import statement

class SelectionModel with ChangeNotifier {
  int? bodyTypeOption;
  int? skinColorOption;
  String? name;
  int? age;
  String? gender;

  void updateBodyType(int option) {
    bodyTypeOption = option;
    notifyListeners();
  }

  void updateSkinColor(int option) {
    skinColorOption = option;
    notifyListeners();
  }

  void updateUserInfo({String? name, int? age, String? gender}) {
    this.name = name;
    this.age = age;
    this.gender = gender;
    notifyListeners();
  }
}
