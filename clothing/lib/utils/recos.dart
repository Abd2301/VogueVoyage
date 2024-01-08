import 'package:flutter/material.dart';

class RecommendationModel with ChangeNotifier {
  Map<int, List<String>> selectedApparelTypes = {
    1: ['Rings', 'Hats', 'Necklace'],
    2: ['Jacket', 'Hoodie', 'Blazer'],
    3: ['T-Shirt', 'Top', 'Shirt', 'Dress'],
    4: ['Shorts', 'Skirt', 'Jeans', 'Pants', 'Cargos'],
    5: ['Shoes', 'Heels', 'Other'],
  };

  void updateApparelType(int carouselIndex, String selectedType) {
    // Logic to update selectedApparelTypes based on carouselIndex and selectedType
    // This is a placeholder; you can implement the logic based on your requirements.
    // For now, I'll just update the first type in the list.
    selectedApparelTypes[carouselIndex] = [selectedType];
    
    // Notify listeners to rebuild the UI
    notifyListeners();
  }
}