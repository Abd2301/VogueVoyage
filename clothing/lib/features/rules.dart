import 'dart:convert';
import 'dart:io';
import 'package:clothing/utils/adjustments.dart';
import 'package:clothing/utils/image_data.dart';
import 'package:csv/csv.dart';
import 'package:clothing/utils/recos.dart';
import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageRules extends StatefulWidget {
  late RecommendationModel? recommendationModel;
  final SelectionModel? selectionModel;
  final HomeModel? homeModel;
  final ImageData? imageData;
  final String label;
  final String colorHex;
  final String csvFilePath;

  ImageRules({super.key, 
     this.recommendationModel,
     this.selectionModel,
     this.homeModel,
     this.imageData,
    required this.label,
    required this.colorHex,
    this.csvFilePath = 'assets/annotations.csv',
  });


  @override
  // ignore: library_private_types_in_public_api
  _ImageRulesState createState() => _ImageRulesState();
}

class _ImageRulesState extends State<ImageRules> {
  late RecommendationModel recommendationModel;
  late SelectionModel selectionModel;
  late HomeModel homeModel;
  late ImageData imageData;


   @override
  void initState() {
    super.initState();
    
    // Initialize RecommendationModel
    Future.delayed(Duration.zero, () {
      recommendationModel = widget.recommendationModel!;
      recommendationModel.updateRecommendation();
      // Load SelectionModel (assuming you want to load this model)
    Future.delayed(Duration.zero, () {
      selectionModel = Provider.of<SelectionModel>(context, listen: false);
      // Add any necessary method calls or logic here
    });

    // Load HomeModel (assuming you want to load this model)
    Future.delayed(Duration.zero, () {
      homeModel = Provider.of<HomeModel>(context, listen: false);
      // Add any necessary method calls or logic here
    });
  
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageRules Demo',
      home: ImageRules(
        recommendationModel: Provider.of<RecommendationModel>(context),
        selectionModel: Provider.of<SelectionModel>(context),
        homeModel: Provider.of<HomeModel>(context),
        imageData: Provider.of<ImageData>(context),
        label: 'Demo',
        colorHex: '#FFFFFF',
      ),
    );
  }

  
  

  

// No idea what this does
      @override
      void didChangeDependencies() {
        super.didChangeDependencies();
      }    

    Future<List<String>> getFilteredMatchingImageIds() async {
      List<String> allImageIds = await _readCsvAndGetImageIds();
      List<String> complementaryFilteredIds =
          await _filterByComplementaryColors(allImageIds);
      return _filterByGenderAndBodyShape(complementaryFilteredIds);
    }

    Future<List<String>> _readCsvAndGetImageIds() async {
      final input = File(widget.csvFilePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      final headers = fields[0].map((e) => e.toString()).toList();
      final idIndex = headers.indexOf('ID');

      List<String> imageIds = [];

      for (var i = 1; i < fields.length; i++) {
        final imageId = fields[i][idIndex]?.toString();
        if (imageId != null) {
          imageIds.add(imageId);
        }
      }

      return imageIds;
    }

    Future<List<String>> _filterByComplementaryColors(
        List<String> imageIds) async {
      List<String> matchingIds = [];

      final input = File(widget.csvFilePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      final headers = fields[0].map((e) => e.toString()).toList();
      final colorIndex = headers.indexOf('color');
      final idIndex = headers.indexOf('ID');

      for (var i = 1; i < fields.length; i++) {
        final imageId = fields[i][idIndex]?.toString();
        final imageColor = fields[i][colorIndex]?.toString();

        if (imageId != null && imageColor != null) {
          final colorRecommendations = complementaryColors[imageColor];
          if (colorRecommendations != null) {
            switch (selectionModel.skinColorOption) {
              case 'Cool':
                if (colorRecommendations['cool']?.contains(imageColor) ??
                    false) {
                  matchingIds.add(imageId);
                }
                break;
              case 'Warm':
                if (colorRecommendations['warm']?.contains(imageColor) ??
                    false) {
                  matchingIds.add(imageId);
                }
                break;
              default:
                final combinedColors = [
                  ...?colorRecommendations['cool'],
                  ...?colorRecommendations['warm'],
                ].toSet().toList();

                if (combinedColors.contains(imageColor)) {
                  matchingIds.add(imageId);
                }
                break;
            }
          }
        }
      }

      return matchingIds;
    }

    Future<List<String>> _filterByGenderAndBodyShape(
        List<String> imageIds) async {
      List<String> filteredIds = [];

      final input = File(widget.csvFilePath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(const CsvToListConverter())
          .toList();

      final headers = fields[0].map((e) => e.toString()).toList();
      final idIndex = headers.indexOf('ID');
      final genderIndex = headers.indexOf('gender');
      final bodyShapeIndex = headers.indexOf('bodyshape');

      for (var imageId in imageIds) {
        final index =
            fields.indexWhere((row) => row[idIndex]?.toString() == imageId);
        if (index != -1) {
          final imageGender = fields[index][genderIndex]?.toString();
          final imageBodyType = fields[index][bodyShapeIndex]?.toString();

          if (imageGender == selectionModel.gender &&
              imageBodyType == selectionModel.bodyTypeOption) {
            filteredIds.add(imageId);
          }
        }
      }

      return filteredIds;
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

