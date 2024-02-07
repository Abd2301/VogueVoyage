import 'package:clothing/screens/user_info.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:provider/provider.dart';
import 'package:clothing/screens/carousels.dart';

class Home extends StatefulWidget {
  String? userId;
  final String? imagePath;
  final int initialPage;
  SelectionModel? selectionModel;
  HomeModel? homeModel;
  BoxToApparelTypeMap? boxToApparelTypeMap;

  Home({
    super.key,
    this.userId,
    this.boxToApparelTypeMap,
    this.homeModel,
    this.selectionModel,
    this.imagePath,
    required this.initialPage,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  int _currentPage = 1; // Assuming you want to start from the CameraScreen
  String? selectedOccasion = 'Casual'; // Default value
  String? selectedApparel = 'T-Shirt'; // Default value
  late HomeModel homeModel;
  late SelectionModel selectionModel;
  late BoxToApparelTypeMap boxToApparelTypeMap;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectionModel = Provider.of<SelectionModel>(context, listen: false);
    homeModel = Provider.of<HomeModel>(context, listen: false);
    boxToApparelTypeMap = Provider.of<BoxToApparelTypeMap>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    final selectionModel = Provider.of<SelectionModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vogue Voyage'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiping to the right
            _pageController.previousPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else if (details.primaryVelocity! < 0) {
            // Swiping to the left
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  CameraScreen(),
                  // CameraScreen as the first page

                  Carousels(
                  ),

                  const UserInfoScreen(),
                  // UserInfoScreen as the third page
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
