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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

_loadUserData() {
  SelectionModel selectionModel = context.read<SelectionModel>();
  _nameController.text = selectionModel.name ?? '';  // Ensure it's not null
  _ageController.text = selectionModel.age?.toString() ?? '';  // Ensure it's not null
  _genderController.text = selectionModel.gender ?? '';  // Ensure it's not null
}


  void _submitForm(BuildContext context) {
    SelectionModel selectionModel = context.read<SelectionModel>();
    selectionModel.updateUserDetails(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      gender: _genderController.text,
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
            Text('Name'),
            TextField(controller: _nameController),
            SizedBox(height: 20),
            Text('Age'),
            TextField(controller: _ageController, keyboardType: TextInputType.number),
            SizedBox(height: 20),
            Text('Gender'),
            TextField(controller: _genderController),
            Spacer(),
            ElevatedButton(
              onPressed: () => _submitForm(context),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
