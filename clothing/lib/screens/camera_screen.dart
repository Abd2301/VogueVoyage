import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clothing/features/model_service.dart';
import 'package:clothing/features/rules.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:provider/provider.dart';

class CameraScreen extends StatefulWidget {
  final PageController pageController;

  const CameraScreen({required this.pageController});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    // Obtain a list of the available cameras on the device.
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        _initializeControllerFuture = _controller.initialize();

        // Set _showRetryButton to true once the controller is initialized
        setState(() {
          _showRetryButton = true;
        });
      }
    });
  }

  Color getPixelColor(ui.Image img, int x, int y) {
    // Get the byte data for the image
    final ByteData byteData = img.toByteData() as ByteData;
    if (byteData != null) {
      // Calculate the offset for the pixel at (x, y)
      final int offset = (y * img.width + x) * 4;

      // Extract the color components (alpha, red, green, blue)
      int alpha = byteData.getUint8(offset);
      int red = byteData.getUint8(offset + 1);
      int green = byteData.getUint8(offset + 2);
      int blue = byteData.getUint8(offset + 3);

      return Color.fromARGB(alpha, red, green, blue);
    } else {
      throw Exception("Failed to get ByteData from Image.");
    }
  }

  Future<Color> extractDominantColor(String path) async {
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);

    final image = await decodeImageFromList(bytes);
    final paletteGenerator = await PaletteGenerator.fromImage(image!);

    // Retrieve the most dominant color
    final Color dominantColor = paletteGenerator.dominantColor!.color;

    return dominantColor;
  }

  Color computeAvgColor(Image img, Rect region) {
    int rTotal = 0;
    int gTotal = 0;
    int bTotal = 0;
    int count = 0;
    ui.Image uiImage = img as ui.Image;

    for (int y = region.top.toInt(); y < region.bottom.toInt(); y++) {
      for (int x = region.left.toInt(); x < region.right.toInt(); x++) {
        final color = getPixelColor(uiImage, x, y);

        rTotal += color.red;
        gTotal += color.green;
        bTotal += color.blue;
        count++;
      }
    }

    final avgR = (rTotal / count).round();
    final avgG = (gTotal / count).round();
    final avgB = (bTotal / count).round();

    return Color.fromRGBO(avgR, avgG, avgB, 1);
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Stack(
      children: [
        CameraPreview(_controller),
        if (_showRetryButton)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the button
              children: [
                ElevatedButton(
                  onPressed: () => _generateOutfit(),
                  child: Text('Generate'),
                ),
              ],
            ),
          ),
      ],
    );
  }

//Generate color and label

  Future<void> _generateOutfit() async {
    try {
      final image = await _controller.takePicture();
      await ModelService.loadModel();

      // Extract the color from the image
      Color color = await extractDominantColor(image.path);

      var prediction = await ModelService.runInference(File(image.path));
      String? label;
      List<String> suggestions = [];
      String colorHex = color.value.toRadixString(16).padLeft(8, '0');

      // Handle prediction result as required
      if (prediction != null) {
        var labelIndex = prediction['label'];
        var confidence = prediction['confidence'];

        // Thresholding based on confidence
        if (confidence >= 0.6) {
          // If confidence is 60% or above
          label = await File('assets/labels.txt')
              .readAsLines()
              .then((lines) => lines[labelIndex]);
        } else {
          // If confidence is below 60%, set default label to "T-shirt"
          label = "T-shirt";
        }

        // Show the prediction
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ImagePreviewDialog(
              imagePath: image.path,
              label: label,
              colorHex: colorHex, // Pass the extracted color to the next page
            ),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

//Pop-up

class ImagePreviewDialog extends StatelessWidget {
  final String? imagePath;
  final String? label;
  final String? colorHex;
  ImagePreviewDialog({this.colorHex, this.imagePath, this.label});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImageDataProvider>(context, listen: false);
    provider.setImageData(ImageData(label: 'YourLabel', colorHex: 'YourColorHex'));

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.brown[400], // Coffee color
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(File(imagePath!)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to home page with index=1
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageRules(selectionModel: context,                    
                          label: label,
                          colorHex: colorHex, 
                        ),
                      ),
                    );
                  },
                  child: Text('Continue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle 'Retry' button action
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
