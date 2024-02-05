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

List<String> getComplementaryColors(String clothingColor, String skinTone) {
  // Check if the clothing color is in the map
  if (complementaryColors.containsKey(clothingColor.toLowerCase())) {
    // Retrieve the sub-map for the clothing color
    var colorMap = complementaryColors[clothingColor.toLowerCase()]!;
    // Check if the skin tone has specific recommendations
    if (colorMap.containsKey(skinTone.toLowerCase())) {
      return colorMap[skinTone.toLowerCase()]!;
    } else if (skinTone.toLowerCase() == 'neutral') {
      // For 'neutral' skin tone, consider combining all suggestions, avoiding duplicates
      var allColors = Set<String>();
      colorMap.values.forEach((list) => allColors.addAll(list));
      return allColors.toList();
    }
  }
  // Return an empty list if there are no matches or if inputs are invalid
  return [];
}

class Carousels extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Outfit Builder'),
      ),
      body: ListView.builder(
        itemCount: 5, // Assuming you have 5 carousels
        itemBuilder: (context, index) => CarouselWidget(index + 1),
      ),
    );
  }
}

class CarouselWidget extends StatelessWidget {
  final int boxNumber;

  CarouselWidget(this.boxNumber);

  @override
  Widget build(BuildContext context) {
    final userSelection = Provider.of<SelectionModel>(context);
    final homeModel = Provider.of<HomeModel>(context);
    final boxToApparelTypeMapProvider =
        Provider.of<BoxToApparelTypeMap>(context);
    List<String> apparelTypes =
        boxToApparelTypeMapProvider.boxToApparelTypeMap[boxNumber] ?? [];
    // Get the user's selected occasion, apparel input, and color
    final selectedOccasion = homeModel.occasion;
    final selectedApparelInput = homeModel.apparelInput;
    final selectedColor = homeModel.apparelColor;
    final selectedGender = userSelection.gender;
    final selectedSkinTone = userSelection.skinColorOption;
    // Determine complementary colors based on the user's selected color
    final recommendedColors =
        getComplementaryColors(selectedColor, selectedSkinTone);

    // Filter products based on the apparel type map, occasion, and complementary colors
    List<Product> filteredProducts = products
        .where((product) =>
            boxToApparelTypeMapProvider.boxToApparelTypeMap[boxNumber]!
                .contains(product.appareltype) &&
            (selectedOccasion.isEmpty ||
                product.occasion.toLowerCase() == 'other' ||
                product.occasion == selectedOccasion) &&
            recommendedColors.contains(product.color) &&
            (selectedGender.isEmpty ||
                product.gender.toLowerCase() == 'other' ||
                product.gender.toLowerCase() == selectedGender.toLowerCase()))
        .toList();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Carousel $boxNumber'), // Carousel title
            PopupMenuButton<String>(
              onSelected: (String value) {
                // You can use this value to do something when an option is selected
                // For example, you might want to filter the displayed products based on the selection
              },
              itemBuilder: (BuildContext context) {
                return apparelTypes.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: Icon(Icons.arrow_drop_down), // Icon for the popup menu
            ),
          ],
        ),
        Container(
          height: 200, // Adjust based on your UI design
          child: ScrollSnapList(
            onItemFocus: (index) {},
            dynamicItemSize: true,
            itemSize: 150,
            scrollDirection: Axis.horizontal,
            itemCount: filteredProducts.length,
            itemBuilder: (context, index) {
              Product product = filteredProducts[index];
              return Card(
                child:
                    Image.asset(product.imagePath), // Display the product image
                // Add more product details here as needed
              );
            },
          ),
        ),
      ],
    );
  }
}
