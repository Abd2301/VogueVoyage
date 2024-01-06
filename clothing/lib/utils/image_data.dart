import 'package:flutter/material.dart';

class ImageDataProvider with ChangeNotifier {
  ImageData? _imageData;

  void setImageData(ImageData data) {
    _imageData = data;
    notifyListeners();
  }

  ImageData? get imageData => _imageData;
}
class ImageData {
  final String label;
  final String colorHex;

  ImageData({required this.label, required this.colorHex});
}
