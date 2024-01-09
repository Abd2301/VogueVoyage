import 'package:flutter/material.dart';

class ImageDataProvider with ChangeNotifier {
  String? _label;
  String? _colorHex;

  get imageData => null;

  void setImageData({required String newLabel, required String newColorHex}) {
    _label = newLabel;
    _colorHex = newColorHex;
    notifyListeners();
  }

  String? get label => _label;
  String? get colorHex => _colorHex;
}