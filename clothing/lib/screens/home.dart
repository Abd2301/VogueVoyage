import 'package:clothing/screens/user_info.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:provider/provider.dart';
import 'package:clothing/features/carousels.dart';

class Home extends StatefulWidget {
  final String? imagePath;
  final int initialPage;
  SelectionModel? selectionModel;
  HomeModel? homeModel;
  ImageDataProvider? imageData;

  Home({super.key, 
    this.imageData,
    this.homeModel,
    this.selectionModel,
    this.imagePath,
    required this.initialPage,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? userId;
  late PageController _pageController;
  int _currentPage = 1; // Assuming you want to start from the CameraScreen
  String? selectedOccasion = 'Casual'; // Default value
  String? selectedApparel = 'T-Shirt'; // Default value
  late HomeModel homeModel; 
  late SelectionModel selectionModel;
  late ImageDataProvider imageData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectionModel = Provider.of<SelectionModel>(context, listen: true);
    homeModel = Provider.of<HomeModel>(context, listen: true);
    imageData = Provider.of<ImageDataProvider>(context, listen: true);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _currentPage = widget.initialPage;
   
  }

  @override
  Widget build(BuildContext context) {
    Future _showOccasionMenu(BuildContext context) async {
      final String? result = await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Occasion'),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Casual');
                },
                child: Text('Casual'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'Formal');
                },
                child: Text('Formal'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 'All');
                },
                child: Text('All'),
              ),
            ],
          );
        },
      );

// Set the selected occasion in HomeModel
      if (result != null) {
        Provider.of<HomeModel>(context, listen: false).setOccasion(result);
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
        Provider.of<HomeModel>(context, listen: false).setApparelInput(result);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vogue Voyage'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! > 0) {
            // Swiping to the right
            _pageController.previousPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else if (details.primaryVelocity! < 0) {
            // Swiping to the left
            _pageController.nextPage(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selected = _showOccasionMenu(context);

                      Provider.of<HomeModel>(context, listen: false)
                          .setOccasion(selected as String);
                    
                  },
                  child: Text(
                      Provider.of<HomeModel>(context).occasion ?? 'Occasion'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final selected = await _showApparelMenu(context);
                    if (selected != null) {
                      Provider.of<HomeModel>(context, listen: false)
                          .setApparelInput(selected);
                    }
                  },
                  child: Text(Provider.of<HomeModel>(context).apparelInput ??
                      'Apparel'),
                ),
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  CameraScreen(
                      pageController:
                          _pageController), // CameraScreen as the first page
                  Padding(
                    padding: EdgeInsets.all(36.0),
                    child: Carousels(selectionModel: selectionModel,homeModel: homeModel, imageData: imageData,);
                                    
                    ), 
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                    child: UserInfoScreen(), // UserInfoScreen as the third page
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
