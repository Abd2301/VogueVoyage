import 'package:flutter/foundation.dart';

class HomeModel with ChangeNotifier {
  String? occasion;
  String? apparelInput;

  void setOccasion(String newOccasion) {
    occasion = newOccasion;
    notifyListeners(); // Notify listeners of the change
  }

  void setApparelInput(String newApparelInput) {
    apparelInput = newApparelInput;
    notifyListeners(); // Notify listeners of the change
  }
}
