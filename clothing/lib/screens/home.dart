import 'package:clothing/utils/image_data.dart';
import 'package:clothing/utils/recos.dart';
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
  RecommendationModel? recommendationModel;

  Home({
    this.recommendationModel,
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
  late HomeModel homeModel; // Declare but don't initialize yet

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    homeModel =
        Provider.of<HomeModel>(context); // Now it's safe to access context
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _currentPage = widget.initialPage;
  }

  @override
  Widget build(BuildContext context) {
    

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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final selected = _showOccasionMenu(context);
                    if (selected != null) {
                      Provider.of<HomeModel>(context, listen: false)
                          .setOccasion(selected as String);
                    }
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
                          _pageController), // CameraScreen as the second page
                  Padding(
                    padding: EdgeInsets.all(36.0),
                    child: Carousels( pageController: _pageController)
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 8.0),
                          child: Text(
                            getBodyShapeDescription(),
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getBodyShapeDescription() {
    String? bodyShapeOption = widget.selectionModel?.bodyTypeOption;

    if (bodyShapeOption == 'Ectomorph') {
      return 'Ectomorphs are generally leaner and find it harder to gain weight or muscle. They often have a faster metabolism.';
    } else if (bodyShapeOption == 'Mesomorph') {
      return 'Mesomorphs tend to have a more athletic build, gaining muscle and losing fat more easily than other body types.';
    } else if (bodyShapeOption == 'Endomorph') {
      return 'Endomorphs typically have a higher body fat percentage and may find it more challenging to lose weight.';
    } else {
      return 'Body shape information not available.';
    }
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

    // Set the selected apparel in HomeModel
    if (result != null) {
      Provider.of<HomeModel>(context, listen: false).setApparelInput(result);
    }
  }
}

class MyCarousel extends StatefulWidget {
  final int carouselIndex;
  final List<String> items;

  MyCarousel({required this.carouselIndex, required this.items});

  @override
  _MyCarouselState createState() => _MyCarouselState();
}

class _MyCarouselState extends State<MyCarousel> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    // Initialize the items based on the widget.apparelType
    items = _getApparelItems(widget.carouselIndex);
  }

  List<String> _getApparelItems(String apparelType) {
    // Implement logic to get the list of items for the given apparelType
    // For now, returning a dummy list
    return ['path/to/image1', 'path/to/image2', 'path/to/image3'];
  }

  List<String> _getApparelTypesForBox(int boxIndex) {
    return boxToApparelTypeMap[boxIndex] ?? [];
  }

  final Map<int, List<String>> boxToApparelTypeMap = {
    1: ['Rings', 'Hats', 'Necklace'],
    2: ['Jacket', 'Hoodie', 'Blazer'],
    3: ['T-Shirt', 'Top', 'Shirt', 'Dress'],
    4: ['Shorts', 'Skirt', 'Jeans', 'Pants', 'Cargos'],
    5: ['Shoes', 'Heels', 'Other'],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CarouselWithButton(apparelType: _getApparelTypesForBox(1)),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: _getApparelTypesForBox(2)),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: _getApparelTypesForBox(3)),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: _getApparelTypesForBox(4)),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: _getApparelTypesForBox(5)),
        ),
      ],
    );
  }
}

class CarouselWithButton extends StatefulWidget {
  final List<String> apparelType;
  final RecommendationModel recommendationModel;
  final SelectionModel selectionModel;
  final HomeModel homeModel;
  final ImageData imageData;

  const CarouselWithButton({
    required this.apparelType,
    required this.recommendationModel,
    required this.selectionModel,
    required this.homeModel,
    required this.imageData,
  });

  @override
  _CarouselWithButtonState createState() => _CarouselWithButtonState();
}

class _CarouselWithButtonState extends State<CarouselWithButton> {
  late List<String> filteredImageIds;

  @override
  void initState() {
    super.initState();
    _updateFilteredImages();
  }

  void _updateFilteredImages() {
    filteredImageIds =
        widget.recommendationModel.getComplementaryClothingRecommendation(
      widget.apparelType,
      widget.selectionModel.skinColorOption,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: ListView.builder(
            itemCount: filteredImageIds.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text('Image ID: ${filteredImageIds[index]}'),
              );
            },
          ),
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () {
              _updateFilteredImages();
            },
            child: const Text('Change Images'),
          ),
        ),
      ],
    );
  }

  void _showChangeImagesDialog(BuildContext context) async {
    final selectedOption = await showDialog<String>(
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

    if (selectedOption != null) {
      updateRecommendationsBasedOnCarousel(
        Provider.of<RecommendationModel>(context, listen: false),
        selectedOption,
      );

      // Update the criteria based on the selected apparel type
      _updateFilteredImages(selectedOption);
    }
  }

  void _updateFilteredImages(String selectedApparelType) {
    // Update the criteria and filter the images based on the selected apparel type
    // You can use the selectedApparelType to filter the images and update the UI accordingly
    setState(() {
      // Update the state and trigger a rebuild of the widget
    });
  }
}
