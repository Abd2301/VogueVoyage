import 'dart:io';
import 'dart:ui' as ui;
import 'package:clothing/features/carousels.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clothing/features/model_service.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:provider/provider.dart';

final Map<int, List<String>> boxToApparelTypeMap = {
  1: ['Rings', 'Hats', 'Necklaces'],
  2: ['Jackets', 'Sweatshirts', 'Hoodies', 'Blazers'],
  3: ['Tshirts', 'Tops', 'Shirts', 'Dresses'],
  4: ['Shorts', 'Skirts', 'Jeans', 'Pants', 'Casual Pants'],
  5: ['Sneakers', 'Boots', 'Heels', 'Formal Shoes']
};

void updateApparelTypeMap(String label) {
  switch (label) {
    case 'Sneakers':
      boxToApparelTypeMap[1] = ['Rings', 'Hats', 'Watches'];
      boxToApparelTypeMap[2] = ['Sweatshirts', 'Jackets', 'Sweaters'];
      boxToApparelTypeMap[3] = ['Tshirts', 'Shirts', 'Tops'];
      boxToApparelTypeMap[4] = ['Causal Pants', 'Pants', 'Jeans'];
      boxToApparelTypeMap[5] = ['Sneakers'];
      break;
    case 'Boots':
      boxToApparelTypeMap[1] = ['Boots', 'Bracelets', 'Scarves'];
      boxToApparelTypeMap[2] = ['Sweaters', 'Sweatshirts', 'Jackets'];
      boxToApparelTypeMap[3] = ['Tops', 'Shirts', 'Tshirts'];
      boxToApparelTypeMap[4] = ['Jeans', 'Pants', 'Leggings'];
      boxToApparelTypeMap[5] = ['Boots'];
      break;
    case 'Blazers':
      boxToApparelTypeMap[1] = ['Rings', 'Ties', 'Pocket Squares'];
      boxToApparelTypeMap[2] = ['Blazers'];
      boxToApparelTypeMap[3] = ['Shirts', 'Tops', 'Dresses'];
      boxToApparelTypeMap[4] = ['Pants', 'Skirts', 'Trousers'];
      boxToApparelTypeMap[5] = ['Formal Shoes'];
      break;
    case 'Hoodies':
      boxToApparelTypeMap[1] = ['Rings', 'Hats', 'Necklaces'];
      boxToApparelTypeMap[2] = ['Hoodies', 'Jackets', 'Sweatshirts'];
      boxToApparelTypeMap[3] = ['Tshirts', 'Shirts', 'Tops'];
      boxToApparelTypeMap[4] = ['Casual Pants', 'Jeans', 'Pants'];
      boxToApparelTypeMap[5] = ['Sneakers', 'Boots'];
      break;
    // Add more cases as needed for other classes
    default:
      boxToApparelTypeMap[1] = ['Rings', 'Hats', 'Necklaces'];
      boxToApparelTypeMap[2] = ['Jackets', 'Sweatshirts', 'Hoodies', 'Blazers'];
      boxToApparelTypeMap[3] = ['Tshirts', 'Tops', 'Shirts', 'Dresses'];
      boxToApparelTypeMap[4] = ['Shorts', 'Skirts', 'Jeans', 'Pants', 'Casual Pants'];
      boxToApparelTypeMap[5] = ['Sneakers', 'Boots', 'Heels', 'Formal Shoes'];
      break;
      
  }
 }

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
  final ImageDataProvider? imageDataProvider;
  
  ImagePreviewDialog(
      {this.colorHex, this.imagePath, this.label, this.imageDataProvider});

  @override
  Widget build(BuildContext context) {
    final imageData = Provider.of<ImageDataProvider>(context, listen: true);
    imageData.setImageData(label: label!, colorHex: colorHex!);

    updateApparelTypeMap(label!);

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
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CarouselX(
                          products: [],
                          boxToApparelTypeMap: boxToApparelTypeMap,
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
