import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/selection.dart'; // Import your SelectionModel file

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _bodyShapeController =  TextEditingController(); 
  TextEditingController _skinToneController =  TextEditingController(); 

  // Dropdown options
  List<String> bodyShapes = ['Ectomorph', 'Mesomorph', 'Endomorph'];
  List<String> skinTones = ['Neutral', 'Warm', 'Cool'];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() {
    SelectionModel selectionModel = context.read<SelectionModel>();
    _nameController.text = selectionModel.name ?? '';
    _ageController.text = selectionModel.age?.toString() ?? '';
    _genderController.text = selectionModel.gender ?? '';
    _bodyShapeController.text =
        selectionModel.bodyTypeOption ?? ''; // Populate body shape
    _skinToneController.text =
        selectionModel.skinColorOption ?? ''; // Populate skin tone
  }

  void _submitForm(BuildContext context) {
    SelectionModel selectionModel = context.read<SelectionModel>();
    selectionModel.updateUserInfo(
        name: _nameController.text,
        age: int.tryParse(_ageController.text) ?? 0,
        gender: _genderController.text,
        bodyTypeOption: _bodyShapeController.text, // Save body shape
        skinColorOption: _skinToneController.text // Save skin tone
        );
    Navigator.pop(context); // Go back to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _genderController,
              decoration: InputDecoration(labelText: 'Gender'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _bodyShapeController.text,
              items: bodyShapes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _bodyShapeController.text = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Body Shape'),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _skinToneController.text,
              items: skinTones.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _skinToneController.text = newValue!;
                });
              },
              decoration: InputDecoration(labelText: 'Skin Tone'),
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 16.0),
                child: ElevatedButton(
                  onPressed: () => _submitForm(context),
                  child: Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
