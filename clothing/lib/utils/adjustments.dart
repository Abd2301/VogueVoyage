import 'package:flutter/foundation.dart';

class HomeModel with ChangeNotifier {
  String occasion = 'other';
  String apparelInput = 'Tshirt';
  String apparelColor = 'White';

  void setOccasion(String newOccasion) {
    occasion = newOccasion;
    notifyListeners(); // Notify listeners of the change
  }

  void setApparelInput(String newApparelInput) {
    apparelInput = newApparelInput;
    notifyListeners(); // Notify listeners of the change
  }

  void setColor(String newColor) {
    apparelColor = newColor;
    notifyListeners(); // Notify listeners of the change
  }
}
