import 'dart:typed_data';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:image/image.dart' as imglib;

class ModelService {
  static Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/vv2.tflite",
      labels: "assets/labels.txt",
    );
  }

 static Future<Map<String, dynamic>?> runInference(File imageFile) async {
    try {
      var inputImage = imglib.decodeImage(imageFile.readAsBytesSync())!;
      var resizedImage = imglib.copyResize(inputImage, width: 512, height: 512);
      var inputBytes = Uint8List.fromList(imglib.encodePng(resizedImage));

      var output = await Tflite.runModelOnBinary(binary: inputBytes);
      return output![0];
    } catch (e) {
      print(e);
      return null;
    }
  }
}