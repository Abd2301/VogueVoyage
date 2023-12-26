import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/selection.dart'; // Import your SelectionModel file
import 'package:clothing/features/submitForm.dart';

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  String? _bodyShape;
  String? _skinTone;
  SelectionModel? selectionModel;

  // Dropdown options
  List<String> bodyShapes = ['Ectomorph', 'Mesomorph', 'Endomorph'];
  List<String> skinTones = ['Neutral', 'Warm', 'Cool'];

  @override
  void initState() {
    super.initState();
    // Initialize the selectionModel after the widget has been created
    selectionModel = context.read<SelectionModel>();
    _loadUserData();
  }

  _loadUserData() {
    if (selectionModel != null) {
      _nameController.text = selectionModel!.name ?? '';
      _ageController.text = selectionModel!.age?.toString() ?? '';
      _genderController.text = selectionModel!.gender ?? '';

      // Check if the values exist in the lists before setting
      _bodyShape = bodyShapes.contains(selectionModel!.bodyTypeOption)
          ? selectionModel!.bodyTypeOption
          : null;

      _skinTone = skinTones.contains(selectionModel!.skinColorOption)
          ? selectionModel!.skinColorOption
          : null;
    }
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
            // Dropdown for Body Shape
            SizedBox(height: 16.0),
            Text('Body Shape',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _bodyShape,
              items: bodyShapes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _bodyShape = newValue;
                });
              },
              isExpanded: true,
              hint: Text('Select Body Shape'),
            ),

            // Dropdown for Skin Tone
            SizedBox(height: 16.0),
            Text('Skin Tone',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _skinTone,
              items: skinTones.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _skinTone = newValue;
                });
              },
              isExpanded: true,
              hint: Text('Select Skin Tone'),
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton(
                  onPressed: () => submitForm,
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
