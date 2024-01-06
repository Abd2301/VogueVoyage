import 'package:flutter/material.dart';

class RecommendationModel with ChangeNotifier {
  String selectedApparelType1 = 'Accessories'; // Default initialization
  String selectedApparelType2 = 'Jackets'; // Default initialization
  String selectedApparelType3 = 'T-Shirt'; // Default initialization
  String selectedApparelType4 = 'Shorts'; // Default initialization
  String selectedApparelType5 = 'Shoes'; // Default initialization
  

  // Function to update the recommendation based on certain criteria or data
  void updateRecommendation({
    String? type1,
    String? type2,
    String? type3,
    String? type4,
    String? type5,
 }) {
    if (type1 != null) selectedApparelType1 = type1;
    if (type2 != null) selectedApparelType2 = type2;
    if (type3 != null) selectedApparelType3 = type3;
    if (type4 != null) selectedApparelType4 = type4;
    if (type5 != null) selectedApparelType5 = type5;

  notifyListeners();
 }
}
