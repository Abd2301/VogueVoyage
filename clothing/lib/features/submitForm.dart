import 'package:clothing/utils/selection.dart';
import 'package:flutter/material.dart';
import 'package:clothing/utils/cloud.dart';


void submitForm(
  BuildContext context, 
  String userId, 
  SelectionModel model
) async {
  try {
    // Upload the SelectionModel object to Firestore
    uploadToFirestore(userId, model); // assuming you want to upload the model in its JSON form

    print('Form submitted with Body Type: ${model.bodyTypeOption}, ' +
          'Skin Color: ${model.skinColorOption}, ' +
          'Name: ${model.name}, ' +
          'Age: ${model.age}, ' +
          'Gender: ${model.gender}');

    // Navigate to home screen
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  } catch (error) {
    print("Error submitting form: $error");
    // Handle the error, maybe show a dialog or toast to the user.
  }
}
