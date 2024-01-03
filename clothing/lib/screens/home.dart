import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'camera_screen.dart';
import 'user_info.dart';
import 'package:clothing/features/image_rules.dart';

class Home extends StatefulWidget {
  final String? imagePath;
  final int initialPage;
  final String? label;
  SelectionModel? selectionModel;
  Home({this.selectionModel, this.imagePath, required this.initialPage, this.label});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? label;
  String? userId;
  late PageController _pageController;
  String selectedApparelType1 = 'Accessories';
  String selectedApparelType2 = 'Outwears';
  String selectedApparelType3 = 'T-Shirt';
  String selectedApparelType4 = 'Shorts';
  String selectedApparelType5 = 'Shoes';
  int _currentPage = 1; // Assuming you want to start from the CameraScreen
  String? selectedOccasion = 'Casual'; // Default value
  String? selectedApparel = 'T-Shirt'; // Default value

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage);
    _currentPage = widget.initialPage;
    label = widget.label;
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
                  onPressed: () => _showOccasionMenu(context),
                  child: Text(selectedOccasion!),
                ),
                ElevatedButton(
                  onPressed: () => _showApparelMenu(context),
                  child: Text(selectedApparel!),
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
                            selectedApparelType1: selectedApparelType1,
                            selectedApparelType2: selectedApparelType2,
                            selectedApparelType3: selectedApparelType3,
                            selectedApparelType4: selectedApparelType4,
                            selectedApparelType5: selectedApparelType5,
                            label: label,
                          ),
                          SizedBox(
                              height:
                                  20), // Add some space between the carousel and the container
                          Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 8.0),
                            child: Text(
                              getDynamicTextBasedOnRule(widget.selectionModel!.bodyTypeOption), // Replace with the actual method to get dynamic text
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

  void _showOccasionMenu(BuildContext context) async {
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
                Navigator.pop(context, 'Both');
              },
              child: Text('Both'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        selectedOccasion = result;
      });
    }
  }

  void _showApparelMenu(BuildContext context) async {
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

    if (result != null) {
      setState(() {
        selectedApparel = result;
      });
    }
  }

  List<String> _getApparelTypesForBox(int boxNumber) {
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
        return ['Shoes'];
      default:
        return [];
    }
  }
}

class MyCarousels extends StatelessWidget {
  final String selectedApparelType1;
  final String selectedApparelType2;
  final String selectedApparelType3;
  final String selectedApparelType4;
  final String selectedApparelType5;
  final String? label;

  const MyCarousels(
      {required this.selectedApparelType1,
      required this.selectedApparelType2,
      required this.selectedApparelType3,
      required this.selectedApparelType4,
      required this.selectedApparelType5,
      this.label});

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
    // Replace this with your logic to fetch or generate a list of image paths based on the apparel type
    return [];
  }

  List<String> _getApparelTypesForBox(int boxNumber) {
    // Replace this with your logic to return a list of apparel types for the given box number
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
        return ['Shoes'];
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
    final List<String> options = _getApparelTypesForBox(widget.apparelType as int);

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
