import 'package:clothing/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/utils/image_data.dart';

final Map<int, List<String>> boxToApparelTypeMap = {
  1: ['rings', 'hats', 'necklace'],
  2: ['jacket', 'hoodie', 'blazer'],
  3: ['t-Shirt', 'top', 'shirt', 'dress'],
  4: ['shorts', 'skirt', 'jeans', 'pants'],
  5: ['shoes', 'heels', 'other'],
};

//General Carousels Widget Algo

class Carousels extends StatefulWidget {
  SelectionModel? selectionModel;
  HomeModel? homeModel;
  ImageDataProvider? imageData;

  Carousels({super.key, this.selectionModel, this.homeModel, this.imageData});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousels> {
  late SelectionModel selectionModel;
  late HomeModel homeModel;
  late ImageDataProvider imageData;

  @override
  void initState() {
    super.initState();

    selectionModel = Provider.of<SelectionModel>(context, listen: true);
    homeModel = Provider.of<HomeModel>(context, listen: true);
    imageData = Provider.of<ImageDataProvider>(context, listen: true);
  }

  List<String> getComplementaryColors(String color, skinColorOption) {
    final colorRecommendations = complementaryColors[color];

    if (colorRecommendations == null) return [];

    switch (skinColorOption) {
      case 'Cool':
        return colorRecommendations['cool'] ??
            []; // Return the list of cool colors
      case 'Warm':
        return colorRecommendations['warm'] ??
            []; // Return the list of warm colors
      default:
        return [
          ...(colorRecommendations['cool'] ?? []),
          ...(colorRecommendations['warm'] ?? [])
        ]; // Return combined list of cool and warm colors
    }
  }

  List<Product> filterProducts(
      List<Product> products,
      SelectionModel selectionModel,
      ImageDataProvider imageData,
      HomeModel homeModel) {
    return products.where((product) {
      List<String> complementaryColorsForUser =
          getComplementaryColors(product.color, selectionModel.skinColorOption);
      // Filter based on gender, apparel type, and occasion
      if (product.gender != selectionModel.gender) return false;
      if (product.appareltype != imageData.label) return true;
      if (product.occasion != homeModel.occasion) return false;
      // Check if the product color is valid for the user's skin color
      if (!complementaryColorsForUser.contains(product.color)) return false;

      return true;
    }).toList();
  }

  List<Product> products = [
    Product('assets/images/dataset/shoe1.png', 'all', 'casual', 'sneakers',
        'white'),
    Product('assets/images/dataset/shoe2.png', 'all', 'casual', 'sneakers',
        'black'),
    Product('assets/images/dataset/shoe3.png', 'all', 'casual', 'sneakers',
        'beige'),
    Product(
        'assets/images/dataset/shoe4.png', 'all', 'all', 'sneakers', 'brown'),
    Product(
        'assets/images/dataset/shoe5.png', 'all', 'casual', 'sneakers', 'blue'),
    Product('assets/images/dataset/shoe6.png', 'all', 'all', 'boots', 'black'),
    Product('assets/images/dataset/shoe7.png', 'all', 'all', 'boots', 'brown'),
    Product('assets/images/dataset/ring1.png', 'all', 'all', 'rings', 'black'),
    Product('assets/images/dataset/ring2.png', 'all', 'all', 'rings', 'silver'),
    Product('assets/images/dataset/ring3.png', 'all', 'all', 'rings', 'gold'),
    Product(
        'assets/images/dataset/shirt1.png', 'all', 'casual', 'shirt', 'black'),
    Product(
        'assets/images/dataset/shirt2.png', 'all', 'casual', 'shirt', 'white'),
    Product(
        'assets/images/dataset/shirt3.png', 'all', 'casual', 'shirt', 'orange'),
    Product(
        'assets/images/dataset/shirt4.png', 'all', 'casual', 'shirt', 'pink'),
    Product(
        'assets/images/dataset/shirt5.png', 'all', 'casual', 'shirt', 'yellow'),
    Product('assets/images/dataset/stripeshirt1.png', 'all', 'casual', 'shirt',
        'blue'),
    Product('assets/images/dataset/stripeshirt2.png', 'all', 'casual', 'shirt',
        'black'),
    Product('assets/images/dataset/stripeshirt3.png', 'all', 'casual', 'shirt',
        'yellow'),
    Product('assets/images/dataset/stripeshirt4.png', 'all', 'casual', 'shirt',
        'pink'),
    Product('assets/images/dataset/stripeshirt5.png', 'all', 'casual', 'shirt',
        'white'),
    Product(
        'assets/images/dataset/shorts1', 'male', 'casual', 'shorts', 'black'),
    Product(
        'assets/images/dataset/shorts2', 'male', 'casual', 'shorts', 'white'),
    Product(
        'assets/images/dataset/shorts3', 'male', 'casual', 'shorts', 'beige'),
    Product(
        'assets/images/dataset/shorts4', 'female', 'casual', 'shorts', 'white'),
    Product(
        'assets/images/dataset/shorts5', 'female', 'casual', 'shorts', 'black'),
    Product(
        'assets/images/dataset/shorts6', 'female', 'casual', 'shorts', 'denim'),
    Product(
        'assets/images/dataset/shorts7', 'female', 'casual', 'shorts', 'beige'),
    Product(
        'assets/images/dataset/jacket1', 'all', 'casual', 'jacket', 'black'),
    Product('assets/images/dataset/jacket2', 'all', 'casual', 'jacket', 'red'),
    Product(
        'assets/images/dataset/jacket3', 'all', 'casual', 'jacket', 'white'),
    Product('assets/images/dataset/jacket4', 'all', 'casual', 'jacket', 'grey'),
    Product('assets/images/dataset/jacket5', 'all', 'casual', 'jacket', 'blue'),
    Product('assets/images/dataset/sweatshirt1.png', 'all', 'casual',
        'sweatshirt', 'black'),
    Product('assets/images/dataset/sweatshirt2.png', 'all', 'casual',
        'sweatshirt', 'blue'),
    Product('assets/images/dataset/sweatshirt3.png', 'all', 'casual',
        'sweatshirt', 'yellow'),
    Product('assets/images/dataset/sweatshirt4.png', 'all', 'casual',
        'sweatshirt', 'red'),
    Product('assets/images/dataset/sweatshirt5.png', 'all', 'casual',
        'sweatshirt', 'white'),
    Product('assets/images/dataset/skirt1', 'female', 'casual', 'mini skirt',
        'pink'),
    Product('assets/images/dataset/skirt2', 'female', 'casual', 'mini skirt',
        'red'),
    Product('assets/images/dataset/skirt3', 'female', 'casual', 'mini skirt',
        'blue'),
    Product('assets/images/dataset/skirt4', 'female', 'casual', 'mini skirt',
        'purple'),
    Product('assets/images/dataset/skirt5', 'female', 'casual', 'mini skirt',
        'yellow'),
    Product('assets/images/dataset/hat1', 'all', 'casual', 'hat', 'black'),
    Product('assets/images/dataset/hat2', 'all', 'casual', 'hat', 'white'),
    Product('assets/images/dataset/hat3', 'all', 'casual', 'hat', 'beige'),
    Product(
        'assets/images/dataset/baggyfit1', 'all', 'casual', 'jeans', 'blue'),
    Product('assets/images/dataset/baggyfit2', 'all', 'casual', 'jeans',
        'faded deep blue'),
    Product(
        'assets/images/dataset/baggyfit3', 'all', 'casual', 'jeans', 'black'),
    Product('assets/images/dataset/baggyfit4', 'all', 'casual', 'jeans',
        'deep blue'),
    Product('assets/images/dataset/baggyfit5', 'all', 'casual', 'jeans',
        'light blue'),
    Product(
        'assets/images/dataset/bootcut1', 'all', 'casual', 'jeans', 'black'),
    Product('assets/images/dataset/bootcut2', 'all', 'casual', 'jeans',
        'deep blue'),
    Product('assets/images/dataset/bootcut3', 'all', 'casual', 'jeans',
        'light blue'),
    Product(
        'assets/images/dataset/bootcut4', 'all', 'casual', 'jeans', 'white'),
    Product(
        'assets/images/dataset/loosefit1', 'all', 'casual', 'jeans', 'black'),
    Product('assets/images/dataset/loosefit2', 'all', 'casual', 'jeans',
        'faded blue'),
    Product('assets/images/dataset/loosefit3', 'all', 'casual', 'jeans',
        'deep blue'),
    Product(
        'assets/images/dataset/loosefit4', 'all', 'casual', 'jeans', 'white'),
    Product(
        'assets/images/dataset/regularfit1', 'all', 'casual', 'jeans', 'black'),
    Product('assets/images/dataset/regularfit2', 'all', 'casual', 'jeans',
        'deep blue'),
    Product(
        'assets/images/dataset/regularfit3', 'all', 'casual', 'jeans', 'white'),
    Product('assets/images/dataset/regularfit4', 'all', 'casual', 'jeans',
        'light blue'),
    Product('assets/images/dataset/skinny1', 'all', 'casual', 'jeans',
        'light blue'),
    Product('assets/images/dataset/skinny2', 'all', 'casual', 'jeans', 'black'),
    Product(
        'assets/images/dataset/skinny3', 'all', 'casual', 'jeans', 'deep blue'),
    Product('assets/images/dataset/skinny4', 'all', 'casual', 'jeans',
        'faded black'),
    Product('assets/images/dataset/pant1', 'all', 'casual', 'pants', 'red'),
    Product('assets/images/dataset/pant2', 'all', 'casual', 'pants', 'yellow'),
    Product('assets/images/dataset/pant3', 'all', 'all', 'pants', 'black'),
    Product('assets/images/dataset/pant4', 'all', 'all', 'pants', 'blue'),
    Product('assets/images/dataset/pant5', 'all', 'all', 'pants', 'grey'),
    Product(
        'assets/images/dataset/tshirt1.png', 'all', 'casual', 'tshirt', 'red'),
    Product('assets/images/dataset/tshirt2.png', 'all', 'casual', 'tshirt',
        'orange'),
    Product('assets/images/dataset/tshirt3.png', 'all', 'casual', 'tshirt',
        'yellow'),
    Product(
        'assets/images/dataset/tshirt4.png', 'all', 'casual', 'tshirt', 'blue'),
    Product('assets/images/dataset/tshirt5.png', 'all', 'casual', 'tshirt',
        'green'),
    Product('assets/images/dataset/tshirt6.png', 'all', 'casual', 'tshirt',
        'white'),
    Product('assets/images/dataset/tshirt7.png', 'all', 'casual', 'tshirt',
        'black'),
    Product(
        'assets/images/dataset/tshirt8.png', 'all', 'casual', 'tshirt', 'grey'),
    Product('assets/images/dataset/tshirt9.png', 'all', 'casual', 'tshirt',
        'brown'),
    Product('assets/images/dataset/graphictee1', 'all', 'casual',
        'graphictshirt', 'white'),
    Product('assets/images/dataset/graphictee2', 'all', 'casual',
        'graphictshirt', 'black'),
    Product('assets/images/dataset/graphictee3', 'all', 'casual',
        'graphictshirt', 'creme'),
    Product('assets/images/dataset/graphictee4', 'all', 'casual',
        'graphictshirt', 'skin colour'),
    Product('assets/images/dataset/graphictee5', 'all', 'casual',
        'graphictshirt', 'blue'),
    Product('assets/images/dataset/hoodie1', 'all', 'casual', 'hoodie', 'blue'),
    Product(
        'assets/images/dataset/hoodie2', 'all', 'casual', 'hoodie', 'green'),
    Product('assets/images/dataset/hoodie3', 'all', 'casual', 'hoodie',
        'light blue'),
    Product('assets/images/dataset/hoodie4', 'all', 'casual', 'hoodie', 'red'),
    Product(
        'assets/images/dataset/hoodie5', 'all', 'casual', 'hoodie', 'yellow'),
    Product(
        'assets/images/dataset/shirt1.png', 'all', 'casual', 'shirt', 'black'),
    Product(
        'assets/images/dataset/shirt2.png', 'all', 'casual', 'shirt', 'white'),
    Product(
        'assets/images/dataset/shirt3.png', 'all', 'casual', 'shirt', 'orange'),
    Product(
        'assets/images/dataset/shirt4.png', 'all', 'casual', 'shirt', 'pink'),
    Product(
        'assets/images/dataset/shirt5.png', 'all', 'casual', 'shirt', 'yellow'),
    Product('assets/images/dataset/stripeshirt1.png', 'all', 'casual', 'shirt',
        'blue'),
    Product('assets/images/dataset/stripeshirt2.png', 'all', 'casual', 'shirt',
        'black'),
    Product('assets/images/dataset/stripeshirt3.png', 'all', 'casual', 'shirt',
        'yellow'),
    Product('assets/images/dataset/stripeshirt4.png', 'all', 'casual', 'shirt',
        'pink'),
    Product('assets/images/dataset/stripeshirt5.png', 'all', 'casual', 'shirt',
        'white'),
    Product(
        'assets/images/dataset/shorts1', 'male', 'casual', 'shorts', 'black'),
    Product(
        'assets/images/dataset/shorts2', 'male', 'casual', 'shorts', 'white'),
    Product(
        'assets/images/dataset/shorts3', 'male', 'casual', 'shorts', 'beige'),
    Product(
        'assets/images/dataset/shorts4', 'female', 'casual', 'shorts', 'white'),
    Product(
        'assets/images/dataset/shorts5', 'female', 'casual', 'shorts', 'black'),
    Product(
        'assets/images/dataset/shorts6', 'female', 'casual', 'shorts', 'denim'),
    Product(
        'assets/images/dataset/shorts7', 'female', 'casual', 'shorts', 'beige'),
    Product('assets/images/dataset/plainblazer1', 'male', 'casual', 'blazer',
        'black'),
    Product('assets/images/dataset/plainblazer2', 'male', 'casual', 'blazer',
        'grey'),
    Product('assets/images/dataset/plainblazer3', 'male', 'casual', 'blazer',
        'blue'),
    Product('assets/images/dataset/plainblazer4', 'male', 'casual', 'blazer',
        'red'),
    Product('assets/images/dataset/plainblazer5', 'male', 'casual', 'blazer',
        'white'),
    Product('assets/images/dataset/printedblazer1', 'male', 'all', 'blazer',
        'black'),
    Product('assets/images/dataset/printedblazer2', 'male', 'all', 'blazer',
        'white'),
    Product('assets/images/dataset/printedblazer3', 'male', 'all', 'blazer',
        'blue'),
    Product(
        'assets/images/dataset/printedblazer4', 'male', 'all', 'blazer', 'red'),
    Product('assets/images/dataset/printedblazer5', 'male', 'all', 'blazer',
        'grey'),
    Product('assets/images/dataset/cargo1', 'all', 'casual', 'cargo pants',
        'black'),
    Product(
        'assets/images/dataset/cargo2', 'all', 'casual', 'cargo pants', 'blue'),
    Product(
        'assets/images/dataset/cargo3', 'all', 'casual', 'cargo pants', 'grey'),
    Product('assets/images/dataset/cargo4', 'all', 'casual', 'cargo pants',
        'green'),
    Product(
        'assets/images/dataset/cargo5', 'all', 'casual', 'cargo pants', 'cream')
  ];

  Map<String, Map<String, List<String>>> complementaryColors = {
    'black': {
      'cool': ['navy', 'gray', 'white', 'black'],
      'warm': ['olive', 'brown', 'white', 'black']
    },
    'white': {
      'cool': ['soft blue', 'gray', 'black', 'white'],
      'warm': ['beige', 'soft pink', 'black', 'white']
    },
    'red': {
      'cool': ['light gray', 'soft blue', 'white', 'black'],
      'warm': ['brown', 'beige', 'white', 'black']
    },
    'blue': {
      'cool': ['soft gray', 'light green', 'white', 'black'],
      'warm': ['beige', 'olive', 'white', 'black']
    },
    'green': {
      'cool': ['soft blue', 'light gray', 'black', 'white'],
      'warm': ['olive', 'beige', 'white', 'black']
    },
    'yellow': {
      'cool': ['beige', 'soft gray', 'black', 'white'],
      'warm': ['light brown', 'soft green', 'black', 'white']
    },
    'orange': {
      'cool': ['mauve', 'soft blue', 'black', 'white'],
      'warm': ['brown', 'soft pink', 'black', 'white']
    },
    'purple': {
      'cool': ['gray', 'soft green', 'black', 'white'],
      'warm': ['mauve', 'beige', 'black', 'white']
    },
    'pink': {
      'cool': ['soft blue', 'gray', 'black', 'white'],
      'warm': ['beige', 'soft gray', 'black', 'white']
    },
    'gray': {
      'cool': ['soft blue', 'olive', 'black', 'white'],
      'warm': ['navy', 'soft green', 'black', 'white']
    },
    'brown': {
      'cool': ['gray', 'soft pink', 'black', 'white'],
      'warm': ['olive', 'soft pink', 'black', 'white']
    },
    'turquoise': {
      'cool': ['gray', 'beige', 'black', 'white'],
      'warm': ['navy', 'olive', 'black', 'white']
    },
    'lavender': {
      'cool': ['gray', 'soft pink', 'black', 'white'],
      'warm': ['olive', 'soft blue', 'black', 'white']
    },
    'teal': {
      'cool': ['gray', 'beige', 'black', 'white'],
      'warm': ['navy', 'olive', 'black', 'white']
    },
    'coral': {
      'cool': ['soft blue', 'beige', 'black', 'white'],
      'warm': ['soft pink', 'beige', 'black', 'white']
    },
    'navy': {
      'cool': ['gray', 'silver', 'black', 'white'],
      'warm': ['olive', 'beige', 'black', 'white']
    },
    'mint': {
      'cool': ['navy', 'gray', 'black', 'white'],
      'warm': ['beige', 'soft blue', 'black', 'white']
    },
    'maroon': {
      'cool': ['gray', 'soft pink', 'black', 'white'],
      'warm': ['beige', 'soft pink', 'black', 'white']
    },
    'gold': {
      'cool': ['navy', 'gray', 'black', 'white'],
      'warm': ['beige', 'navy', 'black', 'white']
    },
    'silver': {
      'cool': ['gray', 'navy', 'black', 'white'],
      'warm': ['navy', 'soft pink', 'black', 'white']
    },
    'peach': {
      'cool': ['gray', 'soft blue', 'black', 'white'],
      'warm': ['beige', 'soft blue', 'black', 'white']
    },
    'olive': {
      'cool': ['gray', 'soft pink', 'black', 'white'],
      'warm': ['soft pink', 'soft blue', 'black', 'white']
    },
    'magenta': {
      'cool': ['gray', 'navy', 'black', 'white'],
      'warm': ['navy', 'beige', 'black', 'white']
    },
    'beige': {
      'cool': ['navy', 'gray', 'black', 'white'],
      'warm': ['gray', 'soft pink', 'black', 'white']
    },
    'indigo': {
      'cool': ['navy', 'gray', 'black', 'white'],
      'warm': ['beige', 'soft pink', 'black', 'white']
    }
  };

  String getBodyShapeDescription() {
    String? bodyShapeOption = selectionModel.bodyTypeOption;

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
                Navigator.pop(context, 'all');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Outfit Builder"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Carousel1(filteredProducts: products),
                Carousel2(filteredProducts: products),
                Carousel3(filteredProducts: products),
                Carousel4(filteredProducts: products),
                Carousel5(filteredProducts: products),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// First Carousel

class Carousel1 extends StatelessWidget {
  final int boxIndex = 1; // Hardcoded boxIndex value for filtering
  final List<Product> filteredProducts;

  Carousel1({required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    // Retrieve allowed apparel types based on boxIndex
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    // Filter the products list based on the allowed apparel types
    List<Product> productsForBoxIndex = filteredProducts
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();

    // Check if productsForBoxIndex is empty and handle it accordingly
    if (productsForBoxIndex.isEmpty) {
      return Center(
          child: Text('No products found for the allowed apparel types.'));
    }

    return Row(
      children: [
        // Your existing ScrollSnapList widget
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, productsForBoxIndex[index]);
              },
              itemCount: productsForBoxIndex.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Handle the selected type (e.g., update the products list)
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[boxIndex]?.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList() ??
                [];
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    // You can customize this function to display the product details as required
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// Second Carousel

class Carousel2 extends StatelessWidget {
  final int boxIndex = 2; // Hardcoded boxIndex value for filtering
  final List<Product> filteredProducts;

  Carousel2({required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    // Retrieve allowed apparel types based on boxIndex
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    // Filter the products list based on the allowed apparel types
    List<Product> productsForBoxIndex = filteredProducts
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();

    // Check if productsForBoxIndex is empty and handle it accordingly
    if (productsForBoxIndex.isEmpty) {
      return Center(
          child: Text('No products found for the allowed apparel types.'));
    }

    return Row(
      children: [
        // Your existing ScrollSnapList widget
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, productsForBoxIndex[index]);
              },
              itemCount: productsForBoxIndex.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Handle the selected type (e.g., update the products list)
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[boxIndex]?.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList() ??
                [];
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    // You can customize this function to display the product details as required
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// Third Carousel

class Carousel3 extends StatelessWidget {
  final int boxIndex = 3; // Hardcoded boxIndex value for filtering
  final List<Product> filteredProducts;

  Carousel3({required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    // Retrieve allowed apparel types based on boxIndex
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    // Filter the products list based on the allowed apparel types
    List<Product> productsForBoxIndex = filteredProducts
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();

    // Check if productsForBoxIndex is empty and handle it accordingly
    if (productsForBoxIndex.isEmpty) {
      return Center(
          child: Text('No products found for the allowed apparel types.'));
    }

    return Row(
      children: [
        // Your existing ScrollSnapList widget
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, productsForBoxIndex[index]);
              },
              itemCount: productsForBoxIndex.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Handle the selected type (e.g., update the products list)
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[boxIndex]?.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList() ??
                [];
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    // You can customize this function to display the product details as required
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// Fourth Carousel

class Carousel4 extends StatelessWidget {
  final int boxIndex = 4; // Hardcoded boxIndex value for filtering
  final List<Product> filteredProducts;

  Carousel4({required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    // Retrieve allowed apparel types based on boxIndex
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    // Filter the products list based on the allowed apparel types
    List<Product> productsForBoxIndex = filteredProducts
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();

    // Check if productsForBoxIndex is empty and handle it accordingly
    if (productsForBoxIndex.isEmpty) {
      return Center(
          child: Text('No products found for the allowed apparel types.'));
    }

    return Row(
      children: [
        // Your existing ScrollSnapList widget
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, productsForBoxIndex[index]);
              },
              itemCount: productsForBoxIndex.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Handle the selected type (e.g., update the products list)
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[boxIndex]?.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList() ??
                [];
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    // You can customize this function to display the product details as required
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}

// Five Carousel

class Carousel5 extends StatelessWidget {
  final int boxIndex = 5; // Hardcoded boxIndex value for filtering
  final List<Product> filteredProducts;

  Carousel5({required this.filteredProducts});

  @override
  Widget build(BuildContext context) {
    // Retrieve allowed apparel types based on boxIndex
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    // Filter the products list based on the allowed apparel types
    List<Product> productsForBoxIndex = filteredProducts
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();

    // Check if productsForBoxIndex is empty and handle it accordingly
    if (productsForBoxIndex.isEmpty) {
      return Center(
          child: Text('No products found for the allowed apparel types.'));
    }

    return Row(
      children: [
        // Your existing ScrollSnapList widget
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, productsForBoxIndex[index]);
              },
              itemCount: productsForBoxIndex.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Handle the selected type (e.g., update the products list)
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[boxIndex]?.map((String type) {
                  return PopupMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList() ??
                [];
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_drop_down),
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(BuildContext context, Product product) {
    // You can customize this function to display the product details as required
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
    );
  }
}
