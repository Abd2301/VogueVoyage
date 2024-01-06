import 'package:clothing/utils/recos.dart';
import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:provider/provider.dart';

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
    final recommendationModel = Provider.of<RecommendationModel>(context);
    
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Outfit Builder',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                      child: Column(
                        children: [
                          MyCarousels(
                            selectedApparelType1:
                                recommendationModel.selectedApparelType1,
                            selectedApparelType2:
                                recommendationModel.selectedApparelType2,
                            selectedApparelType3:
                                recommendationModel.selectedApparelType3,
                            selectedApparelType4:
                                recommendationModel.selectedApparelType4,
                            selectedApparelType5:
                                recommendationModel.selectedApparelType5,
                          ),
                          SizedBox(
                              height:
                                  20), // Add some space between the carousel and the container
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
                  ]),
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

class MyCarousels extends StatelessWidget {
  final String selectedApparelType1;
  final String selectedApparelType2;
  final String selectedApparelType3;
  final String selectedApparelType4;
  final String selectedApparelType5;

  const MyCarousels({
    required this.selectedApparelType1,
    required this.selectedApparelType2,
    required this.selectedApparelType3,
    required this.selectedApparelType4,
    required this.selectedApparelType5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CarouselWithButton(apparelType: selectedApparelType1),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: selectedApparelType2),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: selectedApparelType3),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: selectedApparelType4),
        ),
        Expanded(
          child: CarouselWithButton(apparelType: selectedApparelType5),
        ),
      ],
    );
  }
}

class CarouselWithButton extends StatefulWidget {
  final String apparelType;

  const CarouselWithButton({required this.apparelType});

  @override
  _CarouselWithButtonState createState() => _CarouselWithButtonState();
}

class _CarouselWithButtonState extends State<CarouselWithButton> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    items = _getImagesForApparelType(widget.apparelType);
  }

  List<String> _getImagesForApparelType(String apparelType) {
    return [];
  }

  List<String> _getApparelTypesForBox(int boxNumber) {
    // For apparel type dialog
    switch (boxNumber) {
      case 1:
        return ['Rings', 'Hats', 'Necklace'];
      case 2:
        return ['Jacket', 'Hoodie', 'Blazer'];
      case 3:
        return ['T-Shirt', 'Top', 'Shirt', 'Dress'];
      case 4:
        return ['Shorts', 'Skirt', 'Jeans', 'Pants'];
      case 5:
        return ['Shoes', 'Heels', 'Other'];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: MyCarousel(items: items),
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () => _showChangeImagesDialog(context),
            child: const Text('Change Images'),
          ),
        ),
      ],
    );
  }

  void _showChangeImagesDialog(BuildContext context) async {
    final List<String> options =
        _getApparelTypesForBox(widget.apparelType as int);

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
  }
}

class MyCarousel extends StatelessWidget {
  final List<String> items;

  MyCarousel({required this.items});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.8),
      itemCount: items.length * 100,
      itemBuilder: (context, index) {
        final item = items[index % items.length];
        return buildItem(item);
      },
    );
  }

  Widget buildItem(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        child: Center(
          child: Image.asset(
            item,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
