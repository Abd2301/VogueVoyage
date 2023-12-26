import 'package:flutter/material.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/features/submitForm.dart';
import 'package:provider/provider.dart';

class MyUserPage extends StatelessWidget {
  final String userId;

  MyUserPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    final selectionModel = Provider.of<SelectionModel>(context);

    final PageController _pageController = PageController();
    int _currentPage = 0;

    void _navigateToNextPage() {
      _pageController.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    }

    void _updateUserSelections(SelectionModel selectionModel) {
      selectionModel.updateUserInfo(
        name: selectionModel.name,
        age: selectionModel.age,
        gender: selectionModel.gender,
        bodyTypeOption: selectionModel.bodyTypeOption,
        skinColorOption: selectionModel.skinColorOption,
      );
    }

    void navigateToMain() {
      int? parsedAge = int.tryParse(selectionModel.age.toString());

      if (parsedAge != null) {
        Navigator.pushReplacementNamed(
          context,
          '/main',
          arguments: selectionModel,
        );
      } else {
        print('Invalid age entered');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          UserInputPage(
            onContinuePressed: _navigateToNextPage,
            selectionModel: selectionModel,
          ),
          BodyTypeOptions(
            onContinuePressed: _navigateToNextPage,
            selectionModel: selectionModel,
          ),
          SkinColorOptions(
            onSubmitPressed: () {
              _updateUserSelections(selectionModel);
              submitForm(context, userId, selectionModel);
            },
            selectionModel: selectionModel,
            userId: userId,
          ),
        ],
        onPageChanged: (int page) {
          _currentPage = page;
        },
      ),
    );
  }
}

class UserInputPage extends StatefulWidget {
  final Function onContinuePressed;
  final SelectionModel selectionModel;

  UserInputPage({
    required this.onContinuePressed,
    required this.selectionModel,
  });

  @override
  _UserInputPageState createState() => _UserInputPageState();
}

class _UserInputPageState extends State<UserInputPage> {
  @override
  Widget build(BuildContext context) {
    final selectionModel = widget.selectionModel;

    return Scaffold(
      appBar: AppBar(
        title: Text('User Input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => selectionModel.name = value,
              decoration: InputDecoration(labelText: 'Enter your name'),
            ),
            TextField(
              onChanged: (value) =>
                  selectionModel.age = int.tryParse(value) ?? 0,
              decoration: InputDecoration(labelText: 'Enter your age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text('Select Gender'),
              value: selectionModel.gender.isNotEmpty
                  ? selectionModel.gender
                  : null,
              onChanged: (String? selectedGender) {
                if (selectedGender != null) {
                  selectionModel.updateGender(selectedGender);
                }
              },
              items: ['Male', 'Female', 'Other']
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

class BodyTypeOptions extends StatefulWidget {
  final VoidCallback onContinuePressed;
  final SelectionModel selectionModel;

  BodyTypeOptions({
    required this.onContinuePressed,
    required this.selectionModel,
  });

  @override
  _BodyTypeOptionsState createState() => _BodyTypeOptionsState();
}

class _BodyTypeOptionsState extends State<BodyTypeOptions> {
  String? _selectedOption;

  void _updateUserSelection(String selectedOption) {
    widget.selectionModel.bodyTypeOption = selectedOption;
    setState(() {
      _selectedOption = selectedOption;
    });
  }

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
            buildClickableImage(
                'assets/images/body_type1.png', 'Ectomorph', 'ecto'),
            SizedBox(height: 20),
            buildClickableImage(
                'assets/images/body_type2.png', 'Mesomorph', 'meso'),
            SizedBox(height: 20),
            buildClickableImage(
                'assets/images/body_type3.png', 'Endomorph', 'endo'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onContinuePressed();
              },
              child: Text('Continue'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildClickableImage(
      String imagePath, String optionText, String optionIndex) {
    bool isSelected = _selectedOption == optionIndex;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            _updateUserSelection(optionIndex);
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
  final VoidCallback? onSubmitPressed;
  final SelectionModel? selectionModel;
  final String userId;

  SkinColorOptions({
    this.onSubmitPressed,
    this.selectionModel,
    required this.userId,
  });

  @override
  _SkinColorOptionsState createState() => _SkinColorOptionsState();
}

class _SkinColorOptionsState extends State<SkinColorOptions> {
  String? _selectedOption;

  void _updateUserSelection(String selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
      widget.selectionModel!.skinColorOption = selectedOption;
    });
  }

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
            buildClickableImage(
                'assets/images/skin_color1.png', 'Warm', 'warm'),
            SizedBox(height: 20),
            buildClickableImage(
                'assets/images/skin_color2.png', 'Neutral', 'neutral'),
            SizedBox(height: 20),
            buildClickableImage(
                'assets/images/skin_color3.png', 'Cool', 'cool'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_selectedOption != null) {
                  _updateUserSelection(_selectedOption!);
                  print("userinputmain");
                  print(widget.userId);
                  print(widget.selectionModel!.name); // Fixed here
                  print(widget.selectionModel!.age); // Fixed here
                  print(widget.selectionModel!.gender); // Fixed here
                  print(widget.selectionModel!.skinColorOption);
                  print(widget.selectionModel!.bodyTypeOption);

                  if (widget.selectionModel!.bodyTypeOption != null &&
                      widget.selectionModel!.skinColorOption != null &&
                      widget.userId != null) {
                    submitForm(
                      context,
                      widget.userId,
                      widget.selectionModel!, // Fixed here
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Please complete all selections')));
                  }
                  widget.onSubmitPressed!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please select an option')));
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildClickableImage(
      String imagePath, String optionText, String optionIndex) {
    bool isSelected = _selectedOption == optionIndex;

    return Column(
      children: [
        GestureDetector(
          onTap: () {
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
