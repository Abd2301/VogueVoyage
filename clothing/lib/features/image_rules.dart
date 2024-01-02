import 'package:clothing/utils/selection.dart';

class ImageRules {
  static String getImageForCarousel({
    required String carouselType,
    required String label,
    required SelectionModel userModel,
  }) {
    // Extracting variables from the userModel
    String bodyTypeOption = userModel.bodyTypeOption;
    String skinColorOption = userModel.skinColorOption;

    switch (carouselType) {
      case 'Accessories':
        switch (label) {
          case 'T-shirt':
            return 'assets/images/accessories/tshirt.jpg';
          case 'Dress':
            switch (bodyTypeOption) {
              case 'Mesomorph':
                return 'assets/images/accessories/dress_mesomorph.jpg';
            }
            break;
        }
        break;

      case 'Outwears':
        switch (skinColorOption) {
          case 'Warm':
            return 'assets/images/outwears/warm_tone.jpg';
        }
        break;

      // Add more cases as needed

      default:
        break;
    }

    // Default return
    return 'assets/images/default.jpg';
  }
}
