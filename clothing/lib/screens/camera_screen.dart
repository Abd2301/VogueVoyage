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
import 'package:clothing/utils/adjustments.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  bool _showRetryButton = false;

  @override
  void initState() {
    super.initState();
    _initCameraController();
    // Obtain a list of the available cameras on the device.
    availableCameras().then((cameras) {
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);

        // Set _showRetryButton to true once the controller is initialized
        setState(() {
          _showRetryButton = true;
        });
      }
    });
  }

  Future<void> _initCameraController() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        final tempController =
            CameraController(cameras[0], ResolutionPreset.medium);
        await tempController.initialize();
        if (mounted) {
          setState(() {
            _controller = tempController;
            _showRetryButton = true;
          });
        }
      } else {
        print('No cameras found on this device.');
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
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

  Future _showOccasionMenu(BuildContext context) async {
    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Occasion'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'casual');
              },
              child: Text('Casual'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'formal');
              },
              child: Text('Formal'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'other');
              },
              child: Text('Other'),
            ),
          ],
        );
      },
    );

    // Set the selected occasion in HomeModel
    if (result != null) {
      final homeModel = Provider.of<HomeModel>(context, listen: false);
      homeModel.setOccasion(result);
    }
  }

  Future _showApparelMenu(BuildContext context) async {
    // You can populate this list based on your needs
    final List<String> options = [
      'Tshirts',
      'Tops',
      'Shirts',
      'Jeans',
      'Pants',
      'Shoes',
      'Boots',
      'Skirts',
      'Dresses',
      'Jackets',
      'Blazers',
      'Heels',
      'Hats',
      'Shorts'
    ];

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Apparel Type'),
          children: options
              .map((option) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, option);
                    },
                    child: Text(option),
                  ))
              .toList(),
        );
      },
    );

    // Set the selected apparel input in HomeModel
    if (result != null) {
      final homeModel = Provider.of<HomeModel>(context, listen: false);
      final boxToApparelTypeMapProvider =
          Provider.of<BoxToApparelTypeMap>(context, listen: false);
      homeModel.setApparelInput(result);
      boxToApparelTypeMapProvider.updateApparelTypeMap(result);
      print(boxToApparelTypeMapProvider.boxToApparelTypeMap);
      print(result);
      print("Current ApparelInput: ${homeModel.apparelInput}");
    }
  }

  Future _showColorMenu(BuildContext context) async {
    // You can populate this list based on your needs
    final List<String> options = [
      'Red',
      'Green',
      'Blue',
      'Yellow',
      'Orange',
      'Purple',
      'Black',
      'White',
      'Gray',
      'Pink',
      'Cyan',
      'Magenta',
      'Lime',
      'Maroon',
      'Navy',
      'Olive',
      'Turquoise',
      'Coral',
    ];

    final String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Color'),
          children: options
              .map((option) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, option);
                    },
                    child: Text(option),
                  ))
              .toList(),
        );
      },
    );

    // Set the selected apparel input in HomeModel
    if (result != null) {
      final homeModel = Provider.of<HomeModel>(context, listen: false);
      print(result);
      homeModel.setColor(result);
      print("Current ApparelColor: ${homeModel.apparelColor}");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      // CameraController is not ready yet, show a loading indicator
      return Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CameraPreview(_controller!),
        if (_showRetryButton)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    _generateOutfit(),
                   
                  },
                  child: Text('Generate'),
                ),
              ],
            ),
          ),
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await _showOccasionMenu(context);
                },
                child: Text('Select Occasion'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showApparelMenu(context);
                },
                child: Text('Select Apparel Type'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showColorMenu(context);
                },
                child: Text('Select Color'),
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
      final image = await _controller?.takePicture();
      await ModelService.loadModel();

      // Extract the color from the image
      Color color = await extractDominantColor(image!.path);

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
          label = "Tshirt";
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
    _controller?.dispose();
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
    final boxToApparelTypeMapProvider =
        Provider.of<BoxToApparelTypeMap>(context, listen: false);

    boxToApparelTypeMapProvider.updateApparelTypeMap(label!);

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
                    boxToApparelTypeMapProvider.updateApparelTypeMap(label!);
                    Navigator.pop(context); // Close the dialog
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Carousels(),
                      ),
                    );
                  },
                  child: Text('Continue'),
                ),
                ElevatedButton(
                  onPressed: () {
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
