import 'package:cloud_firestore/cloud_firestore.dart';
import 'selection.dart';

Future<void> uploadToFirestore(
    String userId, SelectionModel selectionModel) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference usersRef = firestore.collection('users');

    // Ensure userId is not null or empty before proceeding
    if (userId.isNotEmpty) {
      DocumentReference docRef = usersRef.doc(userId);

      // Map model data to Firestore fields
      await docRef.set({
        'name': selectionModel.name,
        'age': selectionModel.age,
        'gender': selectionModel.gender,
        'bodyshape': selectionModel.bodyTypeOption,
        'skin undertone': selectionModel.skinColorOption,
      });
    } else {
      print('Error: Invalid userId');
    }
  } catch (error) {
    print('Error uploading data: $error');
    // Handle error, e.g., display a user-friendly message
  }
}
