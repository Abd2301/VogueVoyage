import 'package:clothing/utils/image_data.dart';
import 'package:clothing/utils/product.dart';
import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/selection.dart';

typedef FilterCallback = void Function(String selectedApparelType);
//desired_classes = ['Shirt', 'Blazers', 'Hoodies', 'Skirts', 'Jeans', 'Casual Pants', 'Tshirts', 'Tops', 'Sweatshirts', 'Shorts', 'Sarees', 'Dresses', 'Shrugs', 'Jackets', 'Sweaters', 'Leggings', 'Kurtas']

List<Product> products = [
  Product('assets/images/dataset/shoe1.png', 'other', 'casual', 'Sneakers',
      'white'),
  Product('assets/images/dataset/shoe2.png', 'other', 'casual', 'Sneakers',
      'black'),
  Product('assets/images/dataset/shoe3.png', 'other', 'casual', 'Sneakers',
      'beige'),
  Product(
      'assets/images/dataset/shoe4.png', 'other', 'other', 'Sneakers', 'brown'),
  Product(
      'assets/images/dataset/shoe5.png', 'other', 'casual', 'Sneakers', 'blue'),
  Product(
      'assets/images/dataset/shoe6.png', 'other', 'other', 'Boots', 'black'),
  Product(
      'assets/images/dataset/shoe7.png', 'other', 'other', 'Boots', 'brown'),
  Product(
      'assets/images/dataset/ring1.png', 'other', 'other', 'Rings', 'black'),
  Product(
      'assets/images/dataset/ring2.png', 'other', 'other', 'Rings', 'silver'),
  Product('assets/images/dataset/ring3.png', 'other', 'other', 'Rings', 'gold'),
  Product(
      'assets/images/dataset/shirt1.png', 'other', 'casual', 'Shirts', 'black'),
  Product(
      'assets/images/dataset/shirt2.png', 'other', 'casual', 'Shirts', 'white'),
  Product('assets/images/dataset/shirt3.png', 'other', 'casual', 'Shirts',
      'orange'),
  Product(
      'assets/images/dataset/shirt4.png', 'other', 'casual', 'Shirts', 'pink'),
  Product('assets/images/dataset/shirt5.png', 'other', 'casual', 'Shirts',
      'yellow'),
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
  Product('assets/images/dataset/jacket1.png', 'other', 'casual', 'Jackets',
      'black'),
  Product(
      'assets/images/dataset/jacket2.png', 'other', 'casual', 'Jackets', 'red'),
  Product('assets/images/dataset/jacket3.png', 'other', 'casual', 'Jackets',
      'white'),
  Product('assets/images/dataset/jacket4.png', 'other', 'casual', 'Jackets',
      'grey'),
  Product('assets/images/dataset/jacket5.png', 'other', 'casual', 'Jackets',
      'blue'),
  Product('assets/images/dataset/sweatshirt1.png', 'other', 'casual',
      'Sweatshirts', 'black'),
  Product('assets/images/dataset/sweatshirt2.png', 'other', 'casual',
      'Sweatshirts', 'blue'),
  Product('assets/images/dataset/sweatshirt3.png', 'other', 'casual',
      'Sweatshirts', 'yellow'),
  Product('assets/images/dataset/sweatshirt4.png', 'other', 'casual',
      'Sweatshirts', 'red'),
  Product('assets/images/dataset/sweatshirt5.png', 'other', 'casual',
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
  Product('assets/images/dataset/hat1.png', 'other', 'casual', 'Hats', 'black'),
  Product('assets/images/dataset/hat2.png', 'other', 'casual', 'Hats', 'white'),
  Product('assets/images/dataset/hat3.png', 'other', 'casual', 'Hats', 'beige'),
  Product('assets/images/dataset/baggyjeans1.png', 'other', 'casual', 'Jeans',
      'blue'),
  Product('assets/images/dataset/baggyjeans2.png', 'other', 'casual', 'Jeans',
      'faded deep blue'),
  Product('assets/images/dataset/baggyjeans3.png', 'other', 'casual', 'Jeans',
      'black'),
  Product('assets/images/dataset/baggyjeans4.png', 'other', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/baggyjeans5.png', 'other', 'casual', 'Jeans',
      'light blue'),
  Product('assets/images/dataset/bootcut1.png', 'other', 'casual', 'Jeans',
      'black'),
  Product('assets/images/dataset/bootcut2.png', 'other', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/bootcut3.png', 'other', 'casual', 'Jeans',
      'light blue'),
  Product('assets/images/dataset/bootcut4.png', 'other', 'casual', 'Jeans',
      'white'),
  Product('assets/images/dataset/loosefit1.png', 'other', 'casual', 'Jeans',
      'black'),
  Product('assets/images/dataset/loosefit2.png', 'other', 'casual', 'Jeans',
      'faded blue'),
  Product('assets/images/dataset/loosefit3.png', 'other', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/loosefit4.png', 'other', 'casual', 'Jeans',
      'white'),
  Product('assets/images/dataset/regularfit1.png', 'other', 'casual', 'Jeans',
      'black'),
  Product('assets/images/dataset/regularfit2.png', 'other', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/regularfit3.png', 'other', 'casual', 'Jeans',
      'white'),
  Product('assets/images/dataset/regularfit4.png', 'other', 'casual', 'Jeans',
      'light blue'),
  Product('assets/images/dataset/skinny1.png', 'other', 'casual', 'Jeans',
      'light blue'),
  Product(
      'assets/images/dataset/skinny2.png', 'other', 'casual', 'Jeans', 'black'),
  Product('assets/images/dataset/skinny3.png', 'other', 'casual', 'Jeans',
      'deep blue'),
  Product('assets/images/dataset/skinny4.png', 'other', 'casual', 'Jeans',
      'faded black'),
  Product('assets/images/dataset/pant1.png', 'other', 'casual', 'Pants', 'red'),
  Product(
      'assets/images/dataset/pant2.png', 'other', 'casual', 'Pants', 'yellow'),
  Product(
      'assets/images/dataset/pant3.png', 'other', 'other', 'Pants', 'black'),
  Product('assets/images/dataset/pant4.png', 'other', 'other', 'Pants', 'blue'),
  Product('assets/images/dataset/pant5.png', 'other', 'other', 'Pants', 'grey'),
  Product(
      'assets/images/dataset/tshirt1.png', 'other', 'casual', 'Tshirts', 'red'),
  Product('assets/images/dataset/tshirt2.png', 'other', 'casual', 'Tshirts',
      'orange'),
  Product('assets/images/dataset/tshirt3.png', 'other', 'casual', 'Tshirts',
      'yellow'),
  Product('assets/images/dataset/tshirt4.png', 'other', 'casual', 'Tshirts',
      'blue'),
  Product('assets/images/dataset/tshirt5.png', 'other', 'casual', 'Tshirts',
      'green'),
  Product('assets/images/dataset/tshirt6.png', 'other', 'casual', 'Tshirts',
      'white'),
  Product('assets/images/dataset/tshirt7.png', 'other', 'casual', 'Tshirts',
      'black'),
  Product('assets/images/dataset/tshirt8.png', 'other', 'casual', 'Tshirts',
      'grey'),
  Product('assets/images/dataset/tshirt9.png', 'other', 'casual', 'Tshirts',
      'brown'),
  Product('assets/images/dataset/graphictee1.png', 'other', 'casual', 'Tshirts',
      'white'),
  Product('assets/images/dataset/graphictee2.png', 'other', 'casual', 'Tshirts',
      'black'),
  Product('assets/images/dataset/graphictee3.png', 'other', 'casual', 'Tshirts',
      'creme'),
  Product('assets/images/dataset/graphictee4.png', 'other', 'casual', 'Tshirts',
      'skin colour'),
  Product('assets/images/dataset/graphictee5.png', 'other', 'casual', 'Tshirts',
      'blue'),
  Product(
      'assets/images/dataset/hoodie1.png', 'other', 'casual', 'Hoodie', 'blue'),
  Product('assets/images/dataset/hoodie2.png', 'other', 'casual', 'Hoodie',
      'green'),
  Product('assets/images/dataset/hoodie3.png', 'other', 'casual', 'Hoodie',
      'light blue'),
  Product(
      'assets/images/dataset/hoodie4.png', 'other', 'casual', 'Hoodie', 'red'),
  Product('assets/images/dataset/hoodie5.png', 'other', 'casual', 'Hoodie',
      'yellow'),
  Product(
      'assets/images/dataset/shirt1.png', 'other', 'casual', 'Shirts', 'black'),
  Product(
      'assets/images/dataset/shirt2.png', 'other', 'casual', 'Shirts', 'white'),
  Product('assets/images/dataset/shirt3.png', 'other', 'casual', 'Shirts',
      'orange'),
  Product(
      'assets/images/dataset/shirt4.png', 'other', 'casual', 'Shirts', 'pink'),
  Product('assets/images/dataset/shirt5.png', 'other', 'casual', 'Shirts',
      'yellow'),
  Product('assets/images/dataset/stripshirt1.png', 'other', 'casual', 'Shirts',
      'blue'),
  Product('assets/images/dataset/stripshirt2.png', 'other', 'casual', 'Shirts',
      'black'),
  Product('assets/images/dataset/stripshirt3.png', 'other', 'casual', 'Shirts',
      'yellow'),
  Product('assets/images/dataset/stripshirt4.png', 'other', 'casual', 'Shirts',
      'pink'),
  Product('assets/images/dataset/stripshirt5.png', 'other', 'casual', 'Shirts',
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
  Product('assets/images/dataset/printedblazer1.png', 'male', 'other',
      'Blazers', 'black'),
  Product('assets/images/dataset/printedblazer2.png', 'male', 'other',
      'Blazers', 'white'),
  Product('assets/images/dataset/printedblazer3.png', 'male', 'other',
      'Blazers', 'blue'),
  Product('assets/images/dataset/printedblazer4.png', 'male', 'other',
      'Blazers', 'red'),
  Product('assets/images/dataset/printedblazer5.png', 'male', 'other',
      'Blazers', 'grey'),
  Product('assets/images/dataset/cargo1.png', 'other', 'casual', 'Casual Pants',
      'black'),
  Product('assets/images/dataset/cargo2.png', 'other', 'casual', 'Casual Pants',
      'blue'),
  Product('assets/images/dataset/cargo3.png', 'other', 'casual', 'Casual Pants',
      'grey'),
  Product('assets/images/dataset/cargo4.png', 'other', 'casual', 'Casual Pants',
      'green'),
  Product('assets/images/dataset/cargo5.png', 'other', 'casual', 'Casual Pants',
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
class Carousels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Outfit Builder"),
      ),
      body: Consumer<BoxToApparelTypeMap>(
        builder: (context, boxToApparelTypeMap, child) {
          return ListView.builder(
            itemCount: 5, // As you have 5 categories
            itemBuilder: (context, index) {
              // Adjust index to match your category (1-5)
              return CarouselX(
                boxIndex: index + 1,
              );
            },
          );
        },
      ),
    );
  }
}

class CarouselX extends StatefulWidget {
  final int boxIndex;
  final Function? onInitFilter;

  CarouselX({Key? key, required this.boxIndex, this.onInitFilter})
      : super(key: key);

  @override
  _CarouselXState createState() => _CarouselXState();
}

class _CarouselXState extends State<CarouselX> {
  String? selectedType;
  List<Product> filteredProducts_lvl1 = [];
  List<Product> filteredProducts_lvl2 = [];
  List<Product> currentDisplayList = [];
  @override
  void initState() {
    super.initState();
    // Listen to SelectionModel changes
    final selectionModel = Provider.of<SelectionModel>(context, listen: false);

    // Add _onSelectionModelChanged as a listener to the model
    selectionModel.addListener(_onSelectionModelChanged);
    final homeModel = Provider.of<HomeModel>(context, listen: false);

    // Add _onSelectionModelChanged as a listener to the model
    homeModel.addListener(_onHomeModelChanged);
  }

  void _onSelectionModelChanged() {
    // This function gets called whenever SelectionModel changes
    filterProducts_lvl1(); // Adapt this function as necessary
  }

  void _onHomeModelChanged() {
    // This function gets called whenever SelectionModel changes
    filterProducts_lvl1();
    filterProducts_lvl2();
  }

  void filterProducts_lvl2() {
    final boxToApparelTypeMapProvider =
        Provider.of<BoxToApparelTypeMap>(context, listen: false);
    final homeModel = Provider.of<HomeModel>(context, listen: false);
    print(
    homeModel);
    setState(() {
      filteredProducts_lvl2 = filteredProducts_lvl1.where((product) {
        final bool matchesOccasion = homeModel.occasion.isEmpty ||
            product.occasion == homeModel.occasion ||
            product.occasion == 'other';
        final bool matchesApparelType = homeModel.apparelInput.isEmpty ||
            boxToApparelTypeMapProvider.boxToApparelTypeMap.values
                .any((list) => list.contains(product.appareltype));
        print(filteredProducts_lvl2);
        return matchesOccasion &&
            matchesApparelType; // Include other conditions as necessary
      }).toList();
    });
  }

  void filterProducts_lvl1() {
    final selectionModel = Provider.of<SelectionModel>(context, listen: false);
    final homeModel = Provider.of<HomeModel>(context, listen: false);
    print("Filtering products with selectedType: $selectedType");
    print(
        "SelectionModel - Gender: ${selectionModel.gender}, SkinColorOption: ${selectionModel.skinColorOption}, BodyTypeOption: ${selectionModel.bodyTypeOption}");
    setState(() {
      filteredProducts_lvl1 = products.where((product) {
        final bool matchesGender = selectionModel.gender.isEmpty ||
            product.gender == selectionModel.gender ||
            product.gender == 'other';
        final bool matchesSkinUndertone =
            selectionModel.skinColorOption.isEmpty ||
                getComplementaryColors(
                        homeModel.apparelColor, selectionModel.skinColorOption)
                    .contains(product.color);
        print(filteredProducts_lvl1);
        return matchesGender &&
            matchesSkinUndertone; // Include other conditions as necessary
      }).toList();
    });
  }

  List getComplementaryColors(String apparelColor, String skinColorOption) {
    final colorRecommendations = complementaryColors[apparelColor];

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

  void filterDisplayedItems() {
  // Assuming 'allItems' is accessible and contains all items you might want to display
  if (selectedType == null) {
    currentDisplayList = List.from(filteredProducts_lvl2); // Show all items if no type is selected
  } else {
    currentDisplayList = filteredProducts_lvl2.where((product) {
      return product.appareltype == selectedType; // Ensure `appareltype` is a valid property of `item`
    }).cast<String>().toList();
  }
  // Refresh the UI with the filtered items
  setState(() {});
}


  
  @override
Widget build(BuildContext context) {
  final boxToApparelTypeMapProvider = Provider.of<BoxToApparelTypeMap>(context); // Assuming this is correctly set up

  return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 250,
            child: ListView.builder( // Consider using ListView.builder for efficiency
              itemCount: currentDisplayList.length,
              itemBuilder: (context, index) {
                return _buildListItem(context, currentDisplayList[index]);
              },
            ),
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (String newSelectedType) {
            setState(() {
              selectedType = newSelectedType; // Update the state variable correctly
              filterDisplayedItems(); // Refilter the list based on the new selection
            });
          },
          itemBuilder: (BuildContext context) {
            final boxToApparelTypeMapProvider = Provider.of<BoxToApparelTypeMap>(context, listen: false);
            List<String> apparelTypes = boxToApparelTypeMapProvider.boxToApparelTypeMap[widget.boxIndex] ?? [];
            return apparelTypes.map((String type) {
              return PopupMenuItem<String>(
                value: type,
                child: Text(type),
              );
            }).toList();
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
            // Further details about the product can be displayed here
          ],
        ),
      ),
    );
  }
}