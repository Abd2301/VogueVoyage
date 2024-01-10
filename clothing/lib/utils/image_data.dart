import 'package:flutter/material.dart';

class ImageDataProvider with ChangeNotifier {
  String? label;
  String? colorHex;

  get imageData => null;

  void setImageData({required String label, required String colorHex}) {
    label = label;
    colorHex = colorHex;
    notifyListeners();
  }

}