import 'package:cloud_firestore/cloud_firestore.dart';
import 'selection.dart';



Future<void> uploadToFirestore(userId,SelectionModel selectionModel) async {
    try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        CollectionReference usersRef = firestore.collection('users');
        DocumentReference docRef = usersRef.doc();

        // Map model data to Firestore fields
        await docRef.set({
            'name': selectionModel.name,
            'age': selectionModel.age,
            'gender': selectionModel.gender,
            'bodyshape': selectionModel.bodyTypeOption,
            'skin undertone': selectionModel.skinColorOption,
        });
    } catch (error) {
        print('Error uploading data: $error');
        // Handle error, e.g., display a user-friendly message
    }
}