import 'dart:io';
import 'package:clothing/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:clothing/features/model_service.dart';

class CameraScreen extends StatefulWidget {
  final PageController pageController;

  const CameraScreen({required this.pageController});

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  // ignore: unused_field
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

  Future<void> _generateOutfit() async {
    try {
      final image = await _controller.takePicture();
      await ModelService.loadModel();

      var prediction = await ModelService.runInference(File(image.path));
      String? label;
      List<String> suggestions = [];
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
            builder: (context) => Home(
              imagePath: image.path,
              initialPage: 1,
              label: label,
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

class ImagePreviewDialog extends StatelessWidget {
  final String imagePath;
  final String? label;

  ImagePreviewDialog({required this.imagePath,this.label});

  @override
  Widget build(BuildContext context) {
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
            Image.file(File(imagePath)),
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
                        builder: (context) => Home(
                          imagePath: imagePath,
                          initialPage: 1,
                          label: label,
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
