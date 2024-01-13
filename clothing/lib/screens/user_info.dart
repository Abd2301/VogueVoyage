import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/features/submit_form.dart';

class UserInfoScreen extends StatelessWidget {
  final String? userId;

  const UserInfoScreen({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Consumer<SelectionModel>(
      builder: (context, selectionModel, child) {
        final List<String> bodyShapes = ['ectomorph', 'mesomorph', 'endomorph'];
        final List<String> skinTones = ['neutral', 'warm', 'cool'];
        final List<String> genders = ['male', 'female', 'other'];

        return Scaffold(
          appBar: AppBar(
            title: Text('User Information'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    selectionModel.name = value;
                  },
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    selectionModel.age = int.tryParse(value) ?? 0;
                  },
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16), // Replace SizedBox with Spacer
                DropdownButton<String>(
                  value: selectionModel.gender.isNotEmpty
                      ? selectionModel.gender
                      : null,
                  items: genders
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? newValue) {
                    selectionModel.gender = newValue ?? '';
                  },
                  isExpanded: true,
                  hint: const Text('Select Gender'),
                ),
                const SizedBox(height: 16.0),
                const Text('Body Shape',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectionModel.bodyTypeOption.isNotEmpty
                      ? selectionModel.bodyTypeOption
                      : null,
                  items: bodyShapes
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? newValue) {
                    selectionModel.bodyTypeOption = newValue ?? '';
                  },
                  isExpanded: true,
                  hint: const Text('Select Body Shape'),
                ),
                const SizedBox(height: 16.0),
                const Text('Skin Tone',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectionModel.skinColorOption.isNotEmpty
                      ? selectionModel.skinColorOption
                      : null,
                  items: skinTones
                      .map((String value) => DropdownMenuItem<String>(
                          value: value, child: Text(value)))
                      .toList(),
                  onChanged: (String? newValue) {
                    selectionModel.skinColorOption = newValue ?? '';
                  },
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
                        submitForm(context, userId!, selectionModel);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}