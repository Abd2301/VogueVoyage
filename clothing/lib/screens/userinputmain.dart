import 'package:flutter/material.dart';
import 'package:clothing/utils/selection.dart';
import 'package:provider/provider.dart';


class MyUserPage extends StatefulWidget {
  @override
  _MyUserPageState createState() => _MyUserPageState();
}

class _MyUserPageState extends State<MyUserPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final SelectionModel _selectionModel = SelectionModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          UserInputPage(
            onContinuePressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            selectionModel: _selectionModel, // Pass selectionModel here
          ),
          BodyTypeOptions(
            onContinuePressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            },
            selectionModel: _selectionModel, // Pass selectionModel here
          ),
          SkinColorOptions(
            onSubmitPressed: () {
              _submitForm(context);
            },
            selectionModel: _selectionModel, // Pass selectionModel here
          ),
        ],
        onPageChanged: (int page) {
          setState(() {
            _currentPage = page;
          });
        },
      ),
    );
  }
}

void _submitForm(BuildContext context) {
  // Get the SelectionModel instance
  SelectionModel selectionModel = context.read<SelectionModel>();

  // Perform final submission actions
  print('Form submitted with Body Type: ${selectionModel.bodyTypeOption}, ' +
      'Skin Color: ${selectionModel.skinColorOption}, ' +
      'Name: ${selectionModel.name}, ' +
      'Age: ${selectionModel.age}, ' +
      'Gender: ${selectionModel.gender}');
       Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
}


class UserInputPage extends StatefulWidget {
  final VoidCallback onContinuePressed;
  final SelectionModel selectionModel;

  UserInputPage(
      {required this.onContinuePressed, required this.selectionModel});

  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  String? _selectedGender;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              onChanged: (value) {
                // Handle user input
              },
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            TextField(
              controller: _ageController,
              onChanged: (value) {
                // Handle user input
              },
              decoration: InputDecoration(labelText: 'Enter your age'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text('Select Gender'),
              value: _selectedGender,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
              items: ['Male', 'Female']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Set the values in the _selectionModel
                widget.selectionModel.name = _nameController.text;
                widget.selectionModel.age = int.tryParse(_ageController.text);
                widget.selectionModel.gender = _selectedGender;

                // Continue to the next page
                widget.onContinuePressed();
              },
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

// Import statements remain unchanged

class BodyTypeOptions extends StatefulWidget {
  final VoidCallback onContinuePressed;
  final SelectionModel selectionModel; // Add this line

  BodyTypeOptions(
      {required this.onContinuePressed,
      required this.selectionModel}); // Add the parameter

  @override
  _BodyTypeOptionsState createState() => _BodyTypeOptionsState();
}

class _BodyTypeOptionsState extends State<BodyTypeOptions> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Body Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildClickableImage('assets/body_type1.png', 'Option 1', 0),
            SizedBox(height: 20),
            buildClickableImage('assets/body_type2.png', 'Option 2', 1),
            SizedBox(height: 20),
            buildClickableImage('assets/body_type3.png', 'Option 3', 2),
            ElevatedButton(
              onPressed: widget.onContinuePressed,
              child: Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClickableImage(
      String imagePath, String optionText, int optionIndex) {
    bool isSelected = _selectedOption == optionIndex;

    return Column(
      children: [
        InkWell(
          onTap: () {
            // Handle the click event
            setState(() {
              _selectedOption = optionIndex;
            });
            print('Selected Body Type: $optionText');
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ColorFiltered(
              colorFilter: isSelected
                  ? ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.darken)
                  : ColorFilter.mode(Colors.transparent, BlendMode.clear),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          optionText,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class SkinColorOptions extends StatefulWidget {
  final VoidCallback onSubmitPressed;
  final SelectionModel selectionModel;

  SkinColorOptions(
      {required this.onSubmitPressed, required this.selectionModel});

  @override
  _SkinColorOptionsState createState() => _SkinColorOptionsState();
}

class _SkinColorOptionsState extends State<SkinColorOptions> {
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Skin Undertone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildClickableImage('assets/skin_color1.png', 'Warm', 0),
            SizedBox(height: 20),
            buildClickableImage('assets/skin_color2.png', 'Neutral', 1),
            SizedBox(height: 20),
            buildClickableImage('assets/skin_color3.png', 'Cool', 2),
            ElevatedButton(
              onPressed: widget.onSubmitPressed,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClickableImage(
      String imagePath, String optionText, int optionIndex) {
    bool isSelected = _selectedOption == optionIndex;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            // Handle the click event
            setState(() {
              _selectedOption = optionIndex;
            });
            print('Selected Skin Undertone: $optionText');
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            decoration: BoxDecoration(
              border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ColorFiltered(
              colorFilter: isSelected
                  ? ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.darken)
                  : ColorFilter.mode(Colors.transparent,
                      BlendMode.clear), // Provide a default non-nullable value
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          optionText,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
