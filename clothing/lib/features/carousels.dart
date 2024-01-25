import 'package:clothing/screens/camera_screen.dart';
import 'package:clothing/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/utils/image_data.dart';

typedef FilterCallback = void Function(String selectedApparelType);
//desired_classes = ['Shirt', 'Blazers', 'Hoodies', 'Skirts', 'Jeans', 'Casual Pants', 'Tshirts', 'Tops', 'Sweatshirts', 'Shorts', 'Sarees', 'Dresses', 'Shrugs', 'Jackets', 'Sweaters', 'Leggings', 'Kurtas']

List<Product> products = [
  Product(
      'assets/images/dataset/shoe1.png', 'all', 'casual', 'Sneakers', 'white'),
  Product(
      'assets/images/dataset/shoe2.png', 'all', 'casual', 'Sneakers', 'black'),
  Product(
      'assets/images/dataset/shoe3.png', 'all', 'casual', 'Sneakers', 'beige'),
  Product('assets/images/dataset/shoe4.png', 'all', 'all', 'Sneakers', 'brown'),
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
  Product('assets/images/dataset/shirt4.png', 'all', 'casual', 'shirt', 'pink'),
  Product(
      'assets/images/dataset/shirt5.png', 'all', 'casual', 'shirt', 'yellow'),
  Product(
      'assets/images/dataset/shorts1.png', 'male', 'casual', 'Shorts', 'black'),
  Product(
      'assets/images/dataset/shorts2.png', 'male', 'casual', 'Shorts', 'white'),
  Product(
      'assets/images/dataset/shorts3.png', 'male', 'casual', 'Shorts', 'beige'),
  Product('assets/images/dataset/shorts4.png', 'female', 'casual', 'Shorts',
      'white'),
  Product('assets/images/dataset/shorts5.png', 'female', 'casual', 'Shorts',
      'black'),
  Product('assets/images/dataset/shorts6.png', 'female', 'casual', 'Shorts',
      'denim'),
  Product('assets/images/dataset/shorts7.png', 'female', 'casual', 'Shorts',
      'beige'),
  Product(
      'assets/images/dataset/jacket1.png', 'all', 'casual', 'Jackets', 'black'),
  Product(
      'assets/images/dataset/jacket2.png', 'all', 'casual', 'Jackets', 'red'),
  Product(
      'assets/images/dataset/jacket3.png', 'all', 'casual', 'Jackets', 'white'),
  Product(
      'assets/images/dataset/jacket4.png', 'all', 'casual', 'Jackets', 'grey'),
  Product(
      'assets/images/dataset/jacket5.png', 'all', 'casual', 'Jackets', 'blue'),
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
  Product(
      'assets/images/dataset/skirt1.png', 'female', 'casual', 'Skirts', 'pink'),
  Product(
      'assets/images/dataset/skirt2.png', 'female', 'casual', 'Skirts', 'red'),
  Product(
      'assets/images/dataset/skirt3.png', 'female', 'casual', 'Skirts', 'blue'),
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
  Product(
      'assets/images/dataset/bootcut1.png', 'all', 'casual', 'Jeans', 'black'),
  Product('assets/images/dataset/bootcut2.png', 'all', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/bootcut3.png', 'all', 'casual', 'Jeans',
      'light blue'),
  Product(
      'assets/images/dataset/bootcut4.png', 'all', 'casual', 'Jeans', 'white'),
  Product(
      'assets/images/dataset/loosefit1.png', 'all', 'casual', 'Jeans', 'black'),
  Product('assets/images/dataset/loosefit2.png', 'all', 'casual', 'Jeans',
      'faded blue'),
  Product('assets/images/dataset/loosefit3.png', 'all', 'casual', 'Jeans',
      'deep blue'),
  Product(
      'assets/images/dataset/loosefit4.png', 'all', 'casual', 'Jeans', 'white'),
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
  Product(
      'assets/images/dataset/tshirt2.png', 'all', 'casual', 'Tshirt', 'orange'),
  Product(
      'assets/images/dataset/tshirt3.png', 'all', 'casual', 'Tshirt', 'yellow'),
  Product(
      'assets/images/dataset/tshirt4.png', 'all', 'casual', 'Tshirt', 'blue'),
  Product(
      'assets/images/dataset/tshirt5.png', 'all', 'casual', 'Tshirt', 'green'),
  Product(
      'assets/images/dataset/tshirt6.png', 'all', 'casual', 'Tshirt', 'white'),
  Product(
      'assets/images/dataset/tshirt7.png', 'all', 'casual', 'Tshirt', 'black'),
  Product(
      'assets/images/dataset/tshirt8.png', 'all', 'casual', 'Tshirt', 'grey'),
  Product(
      'assets/images/dataset/tshirt9.png', 'all', 'casual', 'Tshirts', 'brown'),
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
  Product(
      'assets/images/dataset/Hoodie2.png', 'all', 'casual', 'Hoodie', 'green'),
  Product('assets/images/dataset/Hoodie3.png', 'all', 'casual', 'Hoodie',
      'light blue'),
  Product(
      'assets/images/dataset/Hoodie4.png', 'all', 'casual', 'Hoodie', 'red'),
  Product(
      'assets/images/dataset/Hoodie5.png', 'all', 'casual', 'Hoodie', 'yellow'),
  Product(
      'assets/images/dataset/shirt1.png', 'all', 'casual', 'Shirts', 'black'),
  Product(
      'assets/images/dataset/shirt2.png', 'all', 'casual', 'Shirts', 'white'),
  Product(
      'assets/images/dataset/shirt3.png', 'all', 'casual', 'Shirts', 'orange'),
  Product(
      'assets/images/dataset/shirt4.png', 'all', 'casual', 'Shirts', 'pink'),
  Product(
      'assets/images/dataset/shirt5.png', 'all', 'casual', 'Shirts', 'yellow'),
  Product('assets/images/dataset/stripshirt1.png', 'all', 'casual', 'Shirts',
      'blue'),
  Product('assets/images/dataset/stripshirt2.png', 'all', 'casual', 'Shirts',
      'black'),
  Product('assets/images/dataset/stripshirt3.png', 'all', 'casual', 'Shirts',
      'yellow'),
  Product('assets/images/dataset/stripshirt4.png', 'all', 'casual', 'Shirts',
      'pink'),
  Product('assets/images/dataset/stripshirt5.png', 'all', 'casual', 'Shirts',
      'white'),
  Product('assets/images/dataset/plainblazer1.png', 'male', 'casual', 'Blazers',
      'black'),
  Product('assets/images/dataset/plainblazer2.png', 'male', 'casual', 'Blazers',
      'grey'),
  Product('assets/images/dataset/plainblazer3.png', 'male', 'casual', 'Blazers',
      'blue'),
  Product('assets/images/dataset/plainblazer4.png', 'male', 'casual', 'Blazers',
      'red'),
  Product('assets/images/dataset/plainblazer5.png', 'male', 'casual', 'Blazers',
      'white'),
  Product('assets/images/dataset/printedblazer1.png', 'male', 'all', 'Blazers',
      'black'),
  Product('assets/images/dataset/printedblazer2.png', 'male', 'all', 'Blazers',
      'white'),
  Product('assets/images/dataset/printedblazer3.png', 'male', 'all', 'Blazers',
      'blue'),
  Product('assets/images/dataset/printedblazer4.png', 'male', 'all', 'Blazers',
      'red'),
  Product('assets/images/dataset/printedblazer5.png', 'male', 'all', 'Blazers',
      'grey'),
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
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final boxToApparelTypeMap = Provider.of<BoxToApparelTypeMap>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Outfit Builder"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer3<SelectionModel, HomeModel, BoxToApparelTypeMap>(
              builder: (context, selectionModel, homeModel, boxToApparelTypeMap,
                  child) {
                // Rebuild only the widgets that depend on these models
                return ListView(
                  children: [
                    CarouselX(
                      boxIndex: 1,
                      boxToApparelTypeMap:
                          boxToApparelTypeMap.boxToApparelTypeMap,
                    ),
                    CarouselX(
                      boxIndex: 2,
                      boxToApparelTypeMap:
                          boxToApparelTypeMap.boxToApparelTypeMap,
                    ),
                    CarouselX(
                      boxIndex: 3,
                      boxToApparelTypeMap:
                          boxToApparelTypeMap.boxToApparelTypeMap,
                    ),
                    CarouselX(
                      boxIndex: 4,
                      boxToApparelTypeMap:
                          boxToApparelTypeMap.boxToApparelTypeMap,
                    ),
                    CarouselX(
                      boxIndex: 5,
                      boxToApparelTypeMap:
                          boxToApparelTypeMap.boxToApparelTypeMap,
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
  late int? boxIndex;

  late Map<int, List<String>>? boxToApparelTypeMap;

  CarouselX({
    this.boxIndex,
    this.boxToApparelTypeMap,
  });

  @override
  _CarouselXState createState() => _CarouselXState();
}

class _CarouselXState extends State<CarouselX>
    with AutomaticKeepAliveClientMixin {
  List<Product> filteredProducts = [];
  late SelectionModel selectionModel;
  late HomeModel homeModel;
  Map<int, List<String>>? boxToApparelTypeMap; // Declare as a member variable

  @override
  bool get wantKeepAlive => true;
  @override
  void initState() {
    super.initState();
    filterCallback(selectedType);
    boxToApparelTypeMap =
        Provider.of<BoxToApparelTypeMap>(context, listen: false)
            .boxToApparelTypeMap;
    selectionModel = Provider.of<SelectionModel>(context, listen: false);
    homeModel = Provider.of<HomeModel>(context, listen: false);
    filteredProductsList(products, widget.boxIndex);
  }

  List<Product> filteredProductsList(List<Product> products, int? boxIndex) {
    List<String> allowedApparelTypes = boxToApparelTypeMap?[boxIndex] ?? [];

    return products.where((product) {
      return product.gender == selectionModel.gender &&
          (allowedApparelTypes.isEmpty ||
              allowedApparelTypes.contains(product.appareltype)) &&
          product.occasion == homeModel.occasion &&
          getComplementaryColors(product.color, selectionModel.skinColorOption)
              .contains(product.color);
    }).toList();
  }

  List<String> getComplementaryColors(String color, String skinColorOption) {
    final colorRecommendations = complementaryColors[color];

    if (colorRecommendations == null) return [];

    switch (skinColorOption) {
      case 'Cool':
        return colorRecommendations['cool'] ?? [];
      case 'Warm':
        return colorRecommendations['warm'] ?? [];
      default:
        return [
          ...(colorRecommendations['cool'] ?? []),
          ...(colorRecommendations['warm'] ?? [])
        ];
    }
  }

  String selectedType = '';

  void filterProducts() {
    setState(() {
      filteredProducts = filteredProductsList(products, widget.boxIndex);
    });
  }

  void filterCallback(String selectedType) {
    List<String> filteredImagePaths = products
        .where((product) => product.appareltype == selectedType)
        .map((product) => product.imagePath)
        .toList();

    setState(() {
      filteredProducts = products
          .where((product) => product.appareltype == selectedType)
          .toList();
    });

    print('Filtered List for $selectedType: $filteredImagePaths');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final boxToApparelTypeMapProvider =
        Provider.of<BoxToApparelTypeMap>(context);
    final Map<int, List<String>> boxToApparelTypeMap =
        boxToApparelTypeMapProvider.boxToApparelTypeMap;

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
