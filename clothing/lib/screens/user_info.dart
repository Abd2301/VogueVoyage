import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/selection.dart'; 
import 'package:clothing/features/submitForm.dart';

class UserInfoScreen extends StatefulWidget {
  final String? userId;

  const UserInfoScreen({Key? key, this.userId}) : super(key: key);

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String? _gender;
  String? _bodyShape;
  String? _skinTone;
  late SelectionModel selectionModel;

  final List<String> bodyShapes = ['Ectomorph', 'Mesomorph', 'Endomorph'];
  final List<String> skinTones = ['Neutral', 'Warm', 'Cool'];
  final List<String> genders = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    selectionModel = context.read<SelectionModel>();
    _loadUserData();
  }

  void _loadUserData() {
    _nameController.text = selectionModel.name ?? '';
    _ageController.text = selectionModel.age?.toString() ?? '';
    _gender = genders.contains(selectionModel.gender) ? selectionModel.gender : null;
    _bodyShape = bodyShapes.contains(selectionModel.bodyTypeOption) ? selectionModel.bodyTypeOption : null;
    _skinTone = skinTones.contains(selectionModel.skinColorOption) ? selectionModel.skinColorOption : null;
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
            const SizedBox(height: 16.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButton<String>(
              value: _gender,
              items: genders.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newValue) => setState(() => _gender = newValue),
              isExpanded: true,
              hint: const Text('Select Gender'),
            ),
            const SizedBox(height: 16.0),
            const Text('Body Shape', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _bodyShape,
              items: bodyShapes.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newValue) => setState(() => _bodyShape = newValue),
              isExpanded: true,
              hint: const Text('Select Body Shape'),
            ),
            const SizedBox(height: 16.0),
            const Text('Skin Tone', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: _skinTone,
              items: skinTones.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
              onChanged: (String? newValue) => setState(() => _skinTone = newValue),
              isExpanded: true,
              hint: const Text('Select Skin Tone'),
            ),
            Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    submitForm(context, widget.userId!, selectionModel);
                  },
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
