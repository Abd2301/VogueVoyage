import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedApparelType1 = 'Accessories';
  String selectedApparelType2 = 'Outwears';
  String selectedApparelType3 = 'T-Shirt';
  String selectedApparelType4 = 'Shorts';
  String selectedApparelType5 = 'Shoes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outfit Builder'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: MyCarousels(
              selectedApparelType1: selectedApparelType1,
              selectedApparelType2: selectedApparelType2,
              selectedApparelType3: selectedApparelType3,
              selectedApparelType4: selectedApparelType4,
              selectedApparelType5: selectedApparelType5,
            ),
          ),
        ],
      ),
    );
  }

  List<String> _getApparelTypesForBox(int boxNumber) {
    switch (boxNumber) {
      case 1:
        return ['Accessories', 'Hat'];
      case 2:
        return ['Outwears', 'Hoodies'];
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
    final List<String> options = _getApparelTypesForBox(widget.apparelType);

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
      // Update the items list based on the selected option
      setState(() {
        items = _getImagesForApparelType(selectedOption);
      });
    }
  }

  List<String> _getApparelTypesForBox(String apparelType) {
    return _getApparelTypesForBoxNumber(apparelType);
  }

  List<String> _getApparelTypesForBoxNumber(String apparelType) {
    // Your logic for each box
    switch (apparelType) {
      case 'Neckwear':
      case 'Ring':
      case 'Hat':
        return ['Ring', 'Hat', 'Neckwear'];
      case 'Outwears':
      case 'Hoodies':
        return ['Outwears', 'Hoodies'];
      case 'T-Shirt':
      case 'Top':
      case 'Shirt':
      case 'Dress':
        return ['T-Shirt', 'Top', 'Shirt', 'Dress'];
      case 'Shorts':
      case 'Skirt':
      case 'Jeans':
      case 'Pants':
        return ['Shorts', 'Skirt', 'Jeans', 'Pants'];
      case 'Shoes':
        return ['Shoes'];
      default:
        return [];
    }
  }
   List<String> _getImagesForApparelType(String type) {
    // Logic to get the list of images based on the selected type
    // You should replace this with your own logic based on the folder structure
    return [
      'assets/$type/image1.jpg',
      'assets/$type/image2.jpg',
      'assets/$type/image3.jpg',
      // Add more images as needed
    ];
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
