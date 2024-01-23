import 'package:clothing/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/utils/image_data.dart';

typedef OccasionFilterCallback = void Function(String selectedOccasion);

typedef FilterCallback = void Function(String selectedApparelType);
//desired_classes = ['Shirt', 'Blazers', 'Hoodies', 'Skirts', 'Jeans', 'Casual Pants', 'Tshirts', 'Tops', 'Sweatshirts', 'Shorts', 'Sarees', 'Dresses', 'Shrugs', 'Jackets', 'Sweaters', 'Leggings', 'Kurtas']

void updateApparelTypeMap(String label) {
  if (label == 'Sneakers') {
    boxToApparelTypeMap[1] = ['Tshirts', 'jackets', 'Jeans'];
    boxToApparelTypeMap[1] = ['Tshirts', 'jackets', 'Jeans'];
    boxToApparelTypeMap[1] = ['Tshirts', 'Shirts', 'Tops'];
    boxToApparelTypeMap[4] = ['Causal Pants', 'Pants', 'Jeans'];
    boxToApparelTypeMap[5] = ['Sneakers'];
  }
  // Add more conditions as needed
}

final Map<int, List<String>> boxToApparelTypeMap = {
  1: ['Rings', 'Hats', 'Necklaces'],
  2: ['Jackets', 'Sweatshirts', 'Hoodies', 'Blazers'],
  3: ['Tshirts', 'Tops', 'Shirts', 'Dresses'],
  4: ['Shorts', 'Skirts', 'Jeans', 'Pants', 'Casual Pants'],
  5: ['Sneakers', 'Boots', 'Heels', 'Formal Shoes']
};

//General Carousels Widget Algo

class Carousels extends StatefulWidget {
  SelectionModel? selectionModel;
  HomeModel? homeModel;
  ImageDataProvider? imageData;
  final FilterCallback? filterCallback;

  Carousels({
    this.selectionModel,
    this.homeModel,
    this.imageData,
    this.filterCallback,
  });

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousels> {
  late SelectionModel selectionModel;
  late HomeModel homeModel;
  late ImageDataProvider imageData;

  String? selectedOccasion;
  String? selectedApparel;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      selectionModel = widget.selectionModel ?? SelectionModel();
      homeModel = widget.homeModel ?? HomeModel();
      imageData = widget.imageData ?? ImageDataProvider();
    });
  }

  List<String> getComplementaryColors(String color, String skinColorOption) {
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

  List<Product> filteredProducts(List<Product> products, int boxIndex) {
    List<String> allowedApparelTypes = boxToApparelTypeMap[boxIndex] ?? [];

    return products.where((product) {
      return product.gender == selectionModel.gender &&
          (allowedApparelTypes.isEmpty ||
              allowedApparelTypes.contains(product.appareltype)) &&
          product.occasion == homeModel.occasion &&
          getComplementaryColors(product.color, selectionModel.skinColorOption)
              .contains(product.color);
    }).toList();
  }

  List<Product> products = [
    Product('assets/images/dataset/shoe1.png', 'all', 'casual', 'Sneakers',
        'white'),
    Product('assets/images/dataset/shoe2.png', 'all', 'casual', 'Sneakers',
        'black'),
    Product('assets/images/dataset/shoe3.png', 'all', 'casual', 'Sneakers',
        'beige'),
    Product(
        'assets/images/dataset/shoe4.png', 'all', 'all', 'Sneakers', 'brown'),
    Product(
        'assets/images/dataset/shoe5.png', 'all', 'casual', 'Sneakers', 'blue'),
    Product('assets/images/dataset/shoe6.png', 'all', 'all', 'Boots', 'black'),
    Product('assets/images/dataset/shoe7.png', 'all', 'all', 'Boots', 'brown'),
    Product('assets/images/dataset/ring1.png', 'all', 'all', 'Rings', 'black'),
    Product('assets/images/dataset/ring2.png', 'all', 'all', 'Rings', 'silver'),
    Product('assets/images/dataset/ring3.png', 'all', 'all', 'Rings', 'gold'),
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
    Product('assets/images/dataset/shorts1.png', 'male', 'casual', 'Shorts',
        'black'),
    Product('assets/images/dataset/shorts2.png', 'male', 'casual', 'Shorts',
        'white'),
    Product('assets/images/dataset/shorts3.png', 'male', 'casual', 'Shorts',
        'beige'),
    Product('assets/images/dataset/shorts4.png', 'female', 'casual', 'Shorts',
        'white'),
    Product('assets/images/dataset/shorts5.png', 'female', 'casual', 'Shorts',
        'black'),
    Product('assets/images/dataset/shorts6.png', 'female', 'casual', 'Shorts',
        'denim'),
    Product('assets/images/dataset/shorts7.png', 'female', 'casual', 'Shorts',
        'beige'),
    Product('assets/images/dataset/jacket1.png', 'all', 'casual', 'Jackets',
        'black'),
    Product(
        'assets/images/dataset/jacket2.png', 'all', 'casual', 'Jackets', 'red'),
    Product('assets/images/dataset/jacket3.png', 'all', 'casual', 'Jackets',
        'white'),
    Product('assets/images/dataset/jacket4.png', 'all', 'casual', 'Jackets',
        'grey'),
    Product('assets/images/dataset/jacket5.png', 'all', 'casual', 'Jackets',
        'blue'),
    Product('assets/images/dataset/sweatshirt1.png', 'all', 'casual',
        'Sweatshirts', 'black'),
    Product('assets/images/dataset/sweatshirt2.png', 'all', 'casual',
        'Sweatshirts', 'blue'),
    Product('assets/images/dataset/sweatshirt3.png', 'all', 'casual',
        'Sweatshirts', 'yellow'),
    Product('assets/images/dataset/sweatshirt4.png', 'all', 'casual',
        'Sweatshirts', 'red'),
    Product('assets/images/dataset/sweatshirt5.png', 'all', 'casual',
        'Sweatshirts', 'white'),
    Product('assets/images/dataset/skirt1.png', 'female', 'casual', 'Skirts',
        'pink'),
    Product('assets/images/dataset/skirt2.png', 'female', 'casual', 'Skirts',
        'red'),
    Product('assets/images/dataset/skirt3.png', 'female', 'casual', 'Skirts',
        'blue'),
    Product('assets/images/dataset/skirt4.png', 'female', 'casual', 'Skirts',
        'purple'),
    Product('assets/images/dataset/skirt5.png', 'female', 'casual', 'Skirts',
        'yellow'),
    Product('assets/images/dataset/hat1.png', 'all', 'casual', 'Hats', 'black'),
    Product('assets/images/dataset/hat2.png', 'all', 'casual', 'Hats', 'white'),
    Product('assets/images/dataset/hat3.png', 'all', 'casual', 'Hats', 'beige'),
    Product('assets/images/dataset/baggyjeans1.png', 'all', 'casual', 'Jeans',
        'blue'),
    Product('assets/images/dataset/baggyjeans2.png', 'all', 'casual', 'Jeans',
        'faded deep blue'),
    Product('assets/images/dataset/baggyjeans3.png', 'all', 'casual', 'Jeans',
        'black'),
    Product('assets/images/dataset/baggyjeans4.png', 'all', 'casual', 'Jeans',
        'deep blue'),
    Product('assets/images/dataset/baggyjeans5.png', 'all', 'casual', 'Jeans',
        'light blue'),
    Product('assets/images/dataset/bootcut1.png', 'all', 'casual', 'Jeans',
        'black'),
    Product('assets/images/dataset/bootcut2.png', 'all', 'casual', 'Jeans',
        'deep blue'),
    Product('assets/images/dataset/bootcut3.png', 'all', 'casual', 'Jeans',
        'light blue'),
    Product('assets/images/dataset/bootcut4.png', 'all', 'casual', 'Jeans',
        'white'),
    Product('assets/images/dataset/loosefit1.png', 'all', 'casual', 'Jeans',
        'black'),
    Product('assets/images/dataset/loosefit2.png', 'all', 'casual', 'Jeans',
        'faded blue'),
    Product('assets/images/dataset/loosefit3.png', 'all', 'casual', 'Jeans',
        'deep blue'),
    Product('assets/images/dataset/loosefit4.png', 'all', 'casual', 'Jeans',
        'white'),
    Product('assets/images/dataset/regularfit1.png', 'all', 'casual', 'Jeans',
        'black'),
    Product('assets/images/dataset/regularfit2.png', 'all', 'casual', 'Jeans',
        'deep blue'),
    Product('assets/images/dataset/regularfit3.png', 'all', 'casual', 'Jeans',
        'white'),
    Product('assets/images/dataset/regularfit4.png', 'all', 'casual', 'Jeans',
        'light blue'),
    Product('assets/images/dataset/skinny1.png', 'all', 'casual', 'Jeans',
        'light blue'),
    Product(
        'assets/images/dataset/skinny2.png', 'all', 'casual', 'Jeans', 'black'),
    Product('assets/images/dataset/skinny3.png', 'all', 'casual', 'Jeans',
        'deep blue'),
    Product('assets/images/dataset/skinny4.png', 'all', 'casual', 'Jeans',
        'faded black'),
    Product('assets/images/dataset/pant1.png', 'all', 'casual', 'pants', 'red'),
    Product(
        'assets/images/dataset/pant2.png', 'all', 'casual', 'pants', 'yellow'),
    Product('assets/images/dataset/pant3.png', 'all', 'all', 'pants', 'black'),
    Product('assets/images/dataset/pant4.png', 'all', 'all', 'pants', 'blue'),
    Product('assets/images/dataset/pant5.png', 'all', 'all', 'pants', 'grey'),
    Product(
        'assets/images/dataset/tshirt1.png', 'all', 'casual', 'Tshirt', 'red'),
    Product('assets/images/dataset/tshirt2.png', 'all', 'casual', 'Tshirt',
        'orange'),
    Product('assets/images/dataset/tshirt3.png', 'all', 'casual', 'Tshirt',
        'yellow'),
    Product(
        'assets/images/dataset/tshirt4.png', 'all', 'casual', 'Tshirt', 'blue'),
    Product('assets/images/dataset/tshirt5.png', 'all', 'casual', 'Tshirt',
        'green'),
    Product('assets/images/dataset/tshirt6.png', 'all', 'casual', 'Tshirt',
        'white'),
    Product('assets/images/dataset/tshirt7.png', 'all', 'casual', 'Tshirt',
        'black'),
    Product(
        'assets/images/dataset/tshirt8.png', 'all', 'casual', 'Tshirt', 'grey'),
    Product('assets/images/dataset/tshirt9.png', 'all', 'casual', 'Tshirts',
        'brown'),
    Product('assets/images/dataset/graphictee1.png', 'all', 'casual', 'Tshirts',
        'white'),
    Product('assets/images/dataset/graphictee2.png', 'all', 'casual', 'Tshirts',
        'black'),
    Product('assets/images/dataset/graphictee3.png', 'all', 'casual', 'Tshirts',
        'creme'),
    Product('assets/images/dataset/graphictee4.png', 'all', 'casual', 'Tshirts',
        'skin colour'),
    Product('assets/images/dataset/graphictee5.png', 'all', 'casual', 'Tshirts',
        'blue'),
    Product(
        'assets/images/dataset/Hoodie1.png', 'all', 'casual', 'Hoodie', 'blue'),
    Product('assets/images/dataset/Hoodie2.png', 'all', 'casual', 'Hoodie',
        'green'),
    Product('assets/images/dataset/Hoodie3.png', 'all', 'casual', 'Hoodie',
        'light blue'),
    Product(
        'assets/images/dataset/Hoodie4.png', 'all', 'casual', 'Hoodie', 'red'),
    Product('assets/images/dataset/Hoodie5.png', 'all', 'casual', 'Hoodie',
        'yellow'),
    Product(
        'assets/images/dataset/shirt1.png', 'all', 'casual', 'Shirts', 'black'),
    Product(
        'assets/images/dataset/shirt2.png', 'all', 'casual', 'Shirts', 'white'),
    Product('assets/images/dataset/shirt3.png', 'all', 'casual', 'Shirts',
        'orange'),
    Product(
        'assets/images/dataset/shirt4.png', 'all', 'casual', 'Shirts', 'pink'),
    Product('assets/images/dataset/shirt5.png', 'all', 'casual', 'Shirts',
        'yellow'),
    Product('assets/images/dataset/stripeshirt1.png', 'all', 'casual', 'Shirts',
        'blue'),
    Product('assets/images/dataset/stripeshirt2.png', 'all', 'casual', 'Shirts',
        'black'),
    Product('assets/images/dataset/stripeshirt3.png', 'all', 'casual', 'Shirts',
        'yellow'),
    Product('assets/images/dataset/stripeshirt4.png', 'all', 'casual', 'Shirts',
        'pink'),
    Product('assets/images/dataset/stripeshirt5.png', 'all', 'casual', 'Shirts',
        'white'),
    Product('assets/images/dataset/plainBlazer1.png', 'male', 'casual',
        'Blazers', 'black'),
    Product('assets/images/dataset/plainBlazer2.png', 'male', 'casual',
        'Blazers', 'grey'),
    Product('assets/images/dataset/plainBlazer3.png', 'male', 'casual',
        'Blazers', 'blue'),
    Product('assets/images/dataset/plainBlazer4.png', 'male', 'casual',
        'Blazers', 'red'),
    Product('assets/images/dataset/plainBlazer5.png', 'male', 'casual',
        'Blazers', 'white'),
    Product('assets/images/dataset/printedBlazer1.png', 'male', 'all',
        'Blazers', 'black'),
    Product('assets/images/dataset/printedBlazer2.png', 'male', 'all',
        'Blazers', 'white'),
    Product('assets/images/dataset/printedBlazer3.png', 'male', 'all',
        'Blazers', 'blue'),
    Product('assets/images/dataset/printedBlazer4.png', 'male', 'all',
        'Blazers', 'red'),
    Product('assets/images/dataset/printedBlazer5.png', 'male', 'all',
        'Blazers', 'grey'),
    Product('assets/images/dataset/cargo1.png', 'all', 'casual', 'Casual Pants',
        'black'),
    Product('assets/images/dataset/cargo2.png', 'all', 'casual', 'Casual Pants',
        'blue'),
    Product('assets/images/dataset/cargo3.png', 'all', 'casual', 'Casual Pants',
        'grey'),
    Product('assets/images/dataset/cargo4.png', 'all', 'casual', 'Casual Pants',
        'green'),
    Product('assets/images/dataset/cargo5.png', 'all', 'casual', 'Casual Pants',
        'cream')
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
      setState(() {
        selectedOccasion = result;
      });
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
      setState(() {
        selectedApparel = result;
      });
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
            child: Consumer3<SelectionModel, HomeModel, ImageDataProvider>(
              builder: (context, selectionModel, homeModel, imageData, child) {
                // Rebuild only the widgets that depend on these models
                return ListView(
                  children: [
                    CarouselX(
                      boxIndex: 1,
                      imageData: imageData,
                      products: products,
                    ),
                    CarouselX(
                      boxIndex: 2,
                      imageData: imageData,
                      products: products,
                    ),
                    CarouselX(
                      boxIndex: 3,
                      imageData: imageData,
                      products: products,
                    ),
                    CarouselX(
                      boxIndex: 4,
                      imageData: imageData,
                      products: products,
                    ),
                    CarouselX(
                      boxIndex: 5,
                      imageData: imageData,
                      products: products,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CarouselX extends StatefulWidget {
  final int boxIndex;
  final List<Product> products;
  final ImageDataProvider imageData;

  CarouselX({
    required this.boxIndex,
    required this.products,
    required this.imageData,
  });

  @override
  _CarouselXState createState() => _CarouselXState();
}

class _CarouselXState extends State<CarouselX> {
  List<Product> filteredProducts = [];
  String selectedType = '';

  @override
  void initState() {
    super.initState();
    filterProducts();
    widget.imageData.addListener(() {
      setState(() {
        selectedType = widget.imageData.label ?? '';
      });
      filterCallback(selectedType);
    });
  }

  void filterProducts() {
    List<String> allowedApparelTypes =
        boxToApparelTypeMap[widget.boxIndex] ?? [];
    filteredProducts = widget.products
        .where((product) => allowedApparelTypes.contains(product.appareltype))
        .toList();
  }

  void filterCallback(String selectedType) {
    List<String> filteredImagePaths = widget.products
        .where((product) => product.appareltype == selectedType)
        .map((product) => product.imagePath)
        .toList();

    setState(() {
      filteredProducts = widget.products
          .where((product) => product.appareltype == selectedType)
          .toList();
    });

    print('Filtered List for $selectedType: $filteredImagePaths');
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 250,
            child: ScrollSnapList(
              itemBuilder: (context, index) {
                return _buildListItem(context, filteredProducts[index]);
              },
              itemCount: filteredProducts.length,
              itemSize: 150,
              onItemFocus: (index) {},
              dynamicItemSize: true,
            ),
          ),
        ),
        // PopupMenuButton for changing apparel type
        PopupMenuButton<String>(
          onSelected: (String selectedType) {
            // Update the selectedType internally
            setState(() {
              this.selectedType = selectedType;
            });
            filterCallback(selectedType);
          },
          itemBuilder: (BuildContext context) {
            return boxToApparelTypeMap[widget.boxIndex]?.map((String type) {
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
    return SizedBox(
      width: 150,
      height: 300,
      child: Card(
        elevation: 12,
        child: Column(
          children: [
            Image.asset(
              product.imagePath,
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
            ),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }
}
