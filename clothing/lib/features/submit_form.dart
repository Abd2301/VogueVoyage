import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'package:clothing/utils/cloud.dart';


void submitForm(
  BuildContext context, 
  String userId, 
  SelectionModel selectionModel
) async {
  try {
    // Upload the SelectionModel object to Firestore
    uploadToFirestore(userId, selectionModel); // assuming you want to upload the selectionModel in its JSON form

    print('Form submitted with Body Type: ${selectionModel.bodyTypeOption}, Skin Color: ${selectionModel.skinColorOption}, Name: ${selectionModel.name}, Age: ${selectionModel.age}, Gender: ${selectionModel.gender}');

    // Navigate to home screen
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  } catch (error) {
    print("Error submitting form: $error");
    // Handle the error, maybe show a dialog or toast to the user.
  }
}
