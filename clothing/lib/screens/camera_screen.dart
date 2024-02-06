import 'dart:io';
import 'dart:ui' as ui;
import 'package:clothing/features/carousels.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clothing/features/model_service.dart';
import 'package:flutter/services.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/adjustments.dart';

class CameraScreen extends StatefulWidget {
  final PageController pageController;

  const CameraScreen({super.key, required this.pageController});

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
    // Calculate the offset for the pixel at (x, y)
    final int offset = (y * img.width + x) * 4;

    // Extract the color components (alpha, red, green, blue)
    int alpha = byteData.getUint8(offset);
    int red = byteData.getUint8(offset + 1);
    int green = byteData.getUint8(offset + 2);
    int blue = byteData.getUint8(offset + 3);

    return Color.fromARGB(alpha, red, green, blue);
    }

  Future<Color> extractDominantColor(String path) async {
    final data = await rootBundle.load(path);
    final bytes = Uint8List.view(data.buffer);

    final image = await decodeImageFromList(bytes);
    final paletteGenerator = await PaletteGenerator.fromImage(image);

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
              child: const Text('Casual'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'formal');
              },
              child: const Text('Formal'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'all');
              },
              child: const Text('All'),
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
      'T-Shirts',
      'Top',
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
          Provider.of<BoxToApparelTypeMap>(context);
      homeModel.setApparelInput(result);
      boxToApparelTypeMapProvider.updateApparelTypeMap(result);
      print(result);
    }
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => {
                    _generateOutfit(),
                  },
                  child: const Text('Generate'),
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
                child: const Text('Select Occasion'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _showApparelMenu(context);
                },
                child: const Text('Select Apparel Type'),
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
    _controller.dispose();
    super.dispose();
  }
}

//Pop-up
class ImagePreviewDialog extends StatelessWidget {
  final String? imagePath;
  final String? label;
  final String? colorHex;

  const ImagePreviewDialog({super.key, this.colorHex, this.imagePath, this.label});

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
                        builder: (context) => CarouselX(
                          boxToApparelTypeMap:
                              boxToApparelTypeMapProvider.boxToApparelTypeMap,
                        ),
                      ),
                    );
                  },
                  child: const Text('Continue'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BoxToApparelTypeMap with ChangeNotifier {
  final Map<int, List<String>> _boxToApparelTypeMap = {
    1: ['Rings', 'Hats', 'Necklaces'],
    2: ['Jackets', 'Sweatshirts', 'Hoodies', 'Blazers'],
    3: ['Tshirts', 'Tops', 'Shirts', 'Dresses'],
    4: ['Shorts', 'Skirts', 'Jeans', 'Pants', 'Casual Pants'],
    5: ['Sneakers', 'Boots', 'Heels', 'Formal Shoes']
  };
  Map<int, List<String>> get boxToApparelTypeMap => _boxToApparelTypeMap;
  void updateApparelTypeMap(String label) {
    switch (label) {
      case 'Sneakers':
        // Adjust for 'Sneakers'
        _boxToApparelTypeMap[1] = [
          'Rings',
          'Hats'
        ]; // Accessories that may go well with sneakers
        _boxToApparelTypeMap[2] = [
          'Jackets',
          'Sweatshirts'
        ]; // Outerwear options
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = [
          'Jeans',
          'Casual Pants'
        ]; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Sneakers']; // Footwear
        break;

      case 'Boots':
        // Adjust for 'Boots'
        _boxToApparelTypeMap[1] = ['Necklaces', 'Hats']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Jackets']; // Outerwear options
        _boxToApparelTypeMap[3] = ['Shirts', 'Dresses']; // Top wear options
        _boxToApparelTypeMap[4] = ['Skirts', 'Pants']; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Boots']; // Footwear
        break;

      case 'Blazers':
        // Adjust for 'Blazers'
        _boxToApparelTypeMap[1] = [
          'Ties',
          'Pocket Squares'
        ]; // Accessories that pair with blazers
        _boxToApparelTypeMap[2] = ['Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = ['Trousers', 'Pants']; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Heels']; // Footwear
        break;

      case 'Hoodies':
        // Adjust for 'Hoodies'
        _boxToApparelTypeMap[1] = ['Rings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Hoodies', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = [
          'Jeans',
          'Casual Pants'
        ]; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Sneakers', 'Boots']; // Footwear
        break;
      case 'T-Shirts':
        _boxToApparelTypeMap[1] = ['Necklaces', 'Hats']; // Accessories
        _boxToApparelTypeMap[2] = ['Sweatshirts', 'Hoodies']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Jeans', 'Shorts']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Sneakers', 'Casual Shoes']; // Footwear
        break;

      case 'Dresses':
        _boxToApparelTypeMap[1] = ['Rings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Dresses']; // Dresses
        _boxToApparelTypeMap[4] = [
          'Skirts',
          'Casual Pants'
        ]; // Bottom wear for versatility
        _boxToApparelTypeMap[5] = ['Heels', 'Boots']; // Footwear
        break;

      case 'Tops':
        _boxToApparelTypeMap[1] = ['Hats', 'Rings']; // Accessories
        _boxToApparelTypeMap[2] = ['Jackets', 'Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Pants', 'Casual Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Sneakers']; // Footwear
        break;

      case 'Pants':
        _boxToApparelTypeMap[1] = ['Necklaces', 'Rings']; // Accessories
        _boxToApparelTypeMap[2] = ['Sweatshirts', 'Hoodies']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Tops']; // Top wear
        _boxToApparelTypeMap[4] = ['Pants', 'Jeans']; // Pants
        _boxToApparelTypeMap[5] = ['Casual Shoes', 'Boots']; // Footwear
        break;

      case 'Shirts':
        _boxToApparelTypeMap[1] = ['Ties', 'Pocket Squares']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Jackets']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Trousers', 'Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Casual Shoes']; // Footwear
        break;

      case 'Jeans':
        _boxToApparelTypeMap[1] = ['Belts', 'Watches']; // Accessories
        _boxToApparelTypeMap[2] = ['Hoodies', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Jeans']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Boots', 'Sneakers']; // Footwear
        break;

      case 'Skirts':
        _boxToApparelTypeMap[1] = ['Rings', 'Bracelets']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Blouses']; // Top wear
        _boxToApparelTypeMap[4] = ['Skirts']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Heels', 'Flats']; // Footwear
        break;

      case 'Shorts':
        _boxToApparelTypeMap[1] = ['Sunglasses', 'Caps']; // Accessories
        _boxToApparelTypeMap[2] = ['Tshirts', 'Tank Tops']; // Top wear
        _boxToApparelTypeMap[3] = ['Shorts']; // Bottom wear
        _boxToApparelTypeMap[4] = ['Sneakers', 'Sandals']; // Footwear
        _boxToApparelTypeMap[5] = [
          'Backpacks',
          'Crossbody Bags'
        ]; // Bags as an accessory
        break;

      case 'Heels':
        _boxToApparelTypeMap[1] = ['Earrings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Dresses', 'Gowns']; // Dresses and similar
        _boxToApparelTypeMap[3] = ['Skirts', 'Trousers']; // Bottom wear
        _boxToApparelTypeMap[4] = ['Heels']; // Footwear
        _boxToApparelTypeMap[5] = ['Clutches', 'Evening Bags']; // Bags
        break;

      case 'Formal Shoes':
        _boxToApparelTypeMap[1] = ['Cufflinks', 'Ties']; // Accessories
        _boxToApparelTypeMap[2] = ['Suits', 'Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Formal Tops']; // Top wear
        _boxToApparelTypeMap[4] = ['Formal Trousers', 'Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes']; // Footwear
        break;
      default:
        _boxToApparelTypeMap[1] = ['Rings', 'Hats', 'Necklaces'];
        _boxToApparelTypeMap[2] = [
          'Jackets',
          'Sweatshirts',
          'Hoodies',
          'Blazers'
        ];
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops', 'Shirts', 'Dresses'];
        _boxToApparelTypeMap[4] = [
          'Shorts',
          'Skirts',
          'Jeans',
          'Pants',
          'Casual Pants'
        ];
        _boxToApparelTypeMap[5] = [
          'Sneakers',
          'Boots',
          'Heels',
          'Formal Shoes'
        ];
        break;
    }
    notifyListeners();
  }
}
