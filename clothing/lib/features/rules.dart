import 'dart:convert';
import 'dart:io';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:csv/csv.dart';
import 'package:clothing/utils/recos.dart';
import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ImageRules extends StatefulWidget {
  final RecommendationModel? recommendationModel;
  final SelectionModel? selectionModel;
  final HomeModel? homeModel;
  final ImageData? imageData;
  final String csvFilePath;

  ImageRules({
    Key? key,
    this.recommendationModel,
    this.selectionModel,
    this.homeModel,
    this.imageData,
    this.csvFilePath = 'assets/annotations.csv',
  }) : super(key: key);

  @override
  _ImageRulesState createState() => _ImageRulesState();
}

class _ImageRulesState extends State<ImageRules> {
  late List<Map<String, dynamic>> imageDataList = [];

  @override
  void initState() {
    super.initState();
    _loadImageData();
  }

  Future<void> _loadImageData() async {
    final String csvData = await rootBundle.loadString(widget.csvFilePath);
    List<List<dynamic>> rowsAsListOfValues = const CsvToListConverter().convert(csvData);
    List<String> headers = rowsAsListOfValues[0].map((header) => header.toString()).toList();

    setState(() {
      imageDataList = rowsAsListOfValues.sublist(1).map((row) {
        return Map.fromIterables(headers, row);
      }).toList();
    });
  }
  String? selApparelType;
  List<String> getFilteredImages() {
    return imageDataList.where((imageData) {
      return imageData['gender'] == widget.selectionModel?.gender &&
          imageData['bodyshape'] == widget.selectionModel?.bodyTypeOption &&
          imageData['skinundertone'] == widget.selectionModel?.skinColorOption &&
          imageData['occasion'] == widget.homeModel?.occasion &&
          (selApparelType == null || imageData['apparel'] != selApparelType);
    }).map((imageData) => imageData['ID'].toString()).toList();
  }
  
 
  @override
  Widget build(BuildContext context) {
    List<String> filteredImageIds = getFilteredImages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Images'),
      ),
      body: ListView.builder(
        itemCount: filteredImageIds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Image ID: ${filteredImageIds[index]}'),
            // Add more details as required
          );
        },
      ),
    );
  }


Future<List<List<dynamic>>> _readCsv() async {
  final input = File(widget.csvFilePath).openRead();
  return await input.transform(utf8.decoder).transform(const CsvToListConverter()).toList();
}

Future<List<String>> _filterByComplementaryColors(List<String> ids) async {
  final fields = await _readCsv();
  final headers = fields.first.map((e) => e.toString()).toList();

  final colorIndex = headers.indexOf('color');
  final apparelIndex = headers.indexOf('apparel');
  final idIndex = headers.indexOf('ID');

  return ids.where((id) {
    final row = fields.firstWhere((row) => row[idIndex]?.toString() == id, orElse: () => []);
    final color = row[colorIndex]?.toString();
    final apparel = row[apparelIndex]?.toString();

    return color != null && apparel == widget.imageData?.label && _isValidColorForSelection(color);
  }).toList();
}

bool _isValidColorForSelection(String color) {
  final colorRecommendations = complementaryColors[color];
  if (colorRecommendations == null) return false;

  switch (widget.selectionModel?.skinColorOption) {
    case 'Cool':
      return colorRecommendations['cool']?.contains(color) ?? false;
    case 'Warm':
      return colorRecommendations['warm']?.contains(color) ?? false;
    default:
      final combinedColors = [...?colorRecommendations['cool'], ...?colorRecommendations['warm']].toSet();
      return combinedColors.contains(color);
  }
}

List<String> getComplementaryColors() {
  String? skinColorOption = widget.selectionModel?.skinColorOption;
  String colorHex = widget.imageData?.colorHex ?? '';
  
  List<String> complementaryColorsList = [];
  if (complementaryColors.containsKey(colorHex)) {
    complementaryColorsList = complementaryColors[colorHex]?[skinColorOption ?? ''] ?? [];
  }
  return complementaryColorsList;
}

List<String> getComplementaryClothingRecommendation() {
  List<String> complementaryColorsList = getComplementaryColors();
  List<String> filteredImageIds = _filterByComplementaryColors(getFilteredImages());
  
  
  return filteredImageIds;
}
List<String> fetchRecommendations(String apparelType, String color) {

    return ['T-Shirt', 'Shirt', 'Hoodie', ...]; // Example
  }
}
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
  }

