import 'package:flutter/material.dart';


class BoxToApparelTypeMap with ChangeNotifier {
  Map<int, List<String>> _boxToApparelTypeMap = {
    1: ['Rings', 'Hats', 'Necklaces'],
    2: ['Jackets', 'Sweatshirts', 'Hoodies', 'Blazers'],
    3: ['Tshirts', 'Tops', 'Shirts', 'Dresses'],
    4: ['Shorts', 'Skirts', 'Jeans', 'Pants', 'Casual Pants'],
    5: ['Sneakers', 'Boots', 'Heels', 'Formal Shoes']
  };
  Map<int, List<String>> get boxToApparelTypeMap => _boxToApparelTypeMap;
  void updateApparelTypeMap(String label) {
    switch (label) {
      case 'Sneakers':
        // Adjust for 'Sneakers'
        _boxToApparelTypeMap[1] = [
          'Rings',
          'Hats'
        ]; // Accessories that may go well with sneakers
        _boxToApparelTypeMap[2] = [
          'Jackets',
          'Sweatshirts'
        ]; // Outerwear options
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = [
          'Jeans',
          'Casual Pants'
        ]; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Sneakers']; // Footwear
        break;

      case 'Boots':
        // Adjust for 'Boots'
        _boxToApparelTypeMap[1] = ['Necklaces', 'Hats']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Jackets']; // Outerwear options
        _boxToApparelTypeMap[3] = ['Shirts', 'Dresses']; // Top wear options
        _boxToApparelTypeMap[4] = ['Skirts', 'Pants']; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Boots']; // Footwear
        break;

      case 'Blazers':
        // Adjust for 'Blazers'
        _boxToApparelTypeMap[1] = [
          'Ties',
          'Pocket Squares'
        ]; // Accessories that pair with blazers
        _boxToApparelTypeMap[2] = ['Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = ['Trousers', 'Pants']; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Heels']; // Footwear
        break;

      case 'Hoodies':
        // Adjust for 'Hoodies'
        _boxToApparelTypeMap[1] = ['Rings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Hoodies', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops']; // Top wear options
        _boxToApparelTypeMap[4] = [
          'Jeans',
          'Casual Pants'
        ]; // Bottom wear options
        _boxToApparelTypeMap[5] = ['Sneakers', 'Boots']; // Footwear
        break;
      case 'Tshirts':
        _boxToApparelTypeMap[1] = ['Necklaces', 'Hats']; // Accessories
        _boxToApparelTypeMap[2] = ['Sweatshirts', 'Hoodies']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Jeans', 'Shorts']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Sneakers', 'Casual Shoes']; // Footwear
        break;

      case 'Dresses':
        _boxToApparelTypeMap[1] = ['Rings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Dresses']; // Dresses
        _boxToApparelTypeMap[4] = [
          'Skirts',
          'Casual Pants'
        ]; // Bottom wear for versatility
        _boxToApparelTypeMap[5] = ['Heels', 'Boots']; // Footwear
        break;

      case 'Tops':
        _boxToApparelTypeMap[1] = ['Hats', 'Rings']; // Accessories
        _boxToApparelTypeMap[2] = ['Jackets', 'Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Pants', 'Casual Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Sneakers']; // Footwear
        break;

      case 'Pants':
        _boxToApparelTypeMap[1] = ['Necklaces', 'Rings']; // Accessories
        _boxToApparelTypeMap[2] = ['Sweatshirts', 'Hoodies']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Tops']; // Top wear
        _boxToApparelTypeMap[4] = ['Pants', 'Jeans']; // Pants
        _boxToApparelTypeMap[5] = ['Casual Shoes', 'Boots']; // Footwear
        break;

      case 'Shirts':
        _boxToApparelTypeMap[1] = ['Ties', 'Pocket Squares']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Jackets']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Trousers', 'Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes', 'Casual Shoes']; // Footwear
        break;

      case 'Jeans':
        _boxToApparelTypeMap[1] = ['Belts', 'Watches']; // Accessories
        _boxToApparelTypeMap[2] = ['Hoodies', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Tshirts']; // Top wear
        _boxToApparelTypeMap[4] = ['Jeans']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Boots', 'Sneakers']; // Footwear
        break;

      case 'Skirts':
        _boxToApparelTypeMap[1] = ['Rings', 'Bracelets']; // Accessories
        _boxToApparelTypeMap[2] = ['Blazers', 'Sweatshirts']; // Outerwear
        _boxToApparelTypeMap[3] = ['Tops', 'Blouses']; // Top wear
        _boxToApparelTypeMap[4] = ['Skirts']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Heels', 'Flats']; // Footwear
        break;

      case 'Shorts':
        _boxToApparelTypeMap[1] = ['Sunglasses', 'Caps']; // Accessories
        _boxToApparelTypeMap[2] = ['Tshirts', 'Tank Tops']; // Top wear
        _boxToApparelTypeMap[3] = ['Shorts']; // Bottom wear
        _boxToApparelTypeMap[4] = ['Sneakers', 'Sandals']; // Footwear
        _boxToApparelTypeMap[5] = [
          'Backpacks',
          'Crossbody Bags'
        ]; // Bags as an accessory
        break;

      case 'Heels':
        _boxToApparelTypeMap[1] = ['Earrings', 'Necklaces']; // Accessories
        _boxToApparelTypeMap[2] = ['Dresses', 'Gowns']; // Dresses and similar
        _boxToApparelTypeMap[3] = ['Skirts', 'Trousers']; // Bottom wear
        _boxToApparelTypeMap[4] = ['Heels']; // Footwear
        _boxToApparelTypeMap[5] = ['Clutches', 'Evening Bags']; // Bags
        break;

      case 'Formal Shoes':
        _boxToApparelTypeMap[1] = ['Cufflinks', 'Ties']; // Accessories
        _boxToApparelTypeMap[2] = ['Suits', 'Blazers']; // Outerwear
        _boxToApparelTypeMap[3] = ['Shirts', 'Formal Tops']; // Top wear
        _boxToApparelTypeMap[4] = ['Formal Trousers', 'Pants']; // Bottom wear
        _boxToApparelTypeMap[5] = ['Formal Shoes']; // Footwear
        break;
      default:
        _boxToApparelTypeMap[1] = ['Rings', 'Hats', 'Necklaces'];
        _boxToApparelTypeMap[2] = [
          'Jackets',
          'Sweatshirts',
          'Hoodies',
          'Blazers'
        ];
        _boxToApparelTypeMap[3] = ['Tshirts', 'Tops', 'Shirts', 'Dresses'];
        _boxToApparelTypeMap[4] = [
          'Shorts',
          'Skirts',
          'Jeans',
          'Pants',
          'Casual Pants'
        ];
        _boxToApparelTypeMap[5] = [
          'Sneakers',
          'Boots',
          'Heels',
          'Formal Shoes'
        ];
        break;
    }
    notifyListeners();
  }
}
