import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


class CameraScreen extends StatefulWidget {
  final PageController pageController;

  CameraScreen({required this.pageController});

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
        setState(() {});
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _retryCapture(),
                  child: Text('Retry'),
                ),
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

  Future<void> _retryCapture() async {
    setState(() {
      _showRetryButton = false;
    });
    _controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

Future<void> _generateOutfit() async {
  try {
    final image = await _controller.takePicture();

    // Navigate back to the main carousels page
    widget.pageController.animateToPage(
      2,  // The index of the main carousels page in your PageView
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    // Optionally, you can show a dialog or some feedback to the user here

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
