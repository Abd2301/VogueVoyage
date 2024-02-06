import 'package:flutter/material.dart';
import 'package:clothing/utils/selection.dart';
import 'package:clothing/features/submit_form.dart';
import 'package:provider/provider.dart';

class MyUserPage extends StatelessWidget {
  final String userId;

  const MyUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    SelectionModel selectionModel = Provider.of<SelectionModel>(context);

    final PageController pageController = PageController();
    // ignore: unused_local_variable
    int currentPage = 0;

    void navigateToNextPage() {
      pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }

    void updateUserSelections(SelectionModel selectionModel) {
      selectionModel.updateUserInfo(
        name: selectionModel.name,
        age: selectionModel.age,
        gender: selectionModel.gender,
        bodyTypeOption: selectionModel.bodyTypeOption,
        skinColorOption: selectionModel.skinColorOption,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: PageView(
        controller: pageController,
        children: [
          UserInputPage(
            onContinuePressed: navigateToNextPage,
            selectionModel: selectionModel,
          ),
          BodyTypeOptions(
            onContinuePressed: navigateToNextPage,
            selectionModel: selectionModel,
          ),
          SkinColorOptions(
            onSubmitPressed: () {
              updateUserSelections(selectionModel);
              submitForm(context, userId, selectionModel);
            },
            selectionModel: selectionModel,
            userId: userId,
          ),
        ],
        onPageChanged: (int page) {
          currentPage = page;
        },
      ),
    );
  }
}

class UserInputPage extends StatefulWidget {
  final Function onContinuePressed;
  final SelectionModel selectionModel;

  const UserInputPage({super.key, 
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              onChanged: (value) => selectionModel.name = value,
              decoration: const InputDecoration(labelText: 'Enter your name'),
            ),
            TextField(
              onChanged: (value) =>
                  selectionModel.age = int.tryParse(value) ?? 0,
              decoration: const InputDecoration(labelText: 'Enter your age'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              hint: const Text('Select Gender'),
              value: selectionModel.gender.isNotEmpty
                  ? selectionModel.gender
                  : null,
              onChanged: (String? selectedGender) {
                if (selectedGender != null) {
                  selectionModel.updateUserInfo(gender: selectedGender);
                }
              },
              items: ['male', 'female', 'other']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onContinuePressed();
              },
              child: const Text('Continue'),
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

  const BodyTypeOptions({super.key, 
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
        title: const Text('Body Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildClickableImage(
                'assets/images/body_type1.png', 'Ectomorph', 'ectomorph'),
            const SizedBox(height: 20),
            buildClickableImage(
                'assets/images/body_type2.png', 'Mesomorph', 'mesomorph'),
            const SizedBox(height: 20),
            buildClickableImage(
                'assets/images/body_type3.png', 'Endomorph', 'endomorph'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onContinuePressed();
              },
              child: const Text('Continue'),
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
            duration: const Duration(milliseconds: 300),
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
                  : const ColorFilter.mode(Colors.transparent, BlendMode.clear),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          optionText,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

class SkinColorOptions extends StatefulWidget {
  final VoidCallback? onSubmitPressed;
  final SelectionModel? selectionModel;
  final String userId;

  const SkinColorOptions({super.key, 
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
        title: const Text('Skin Undertone'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildClickableImage(
                'assets/images/skin_color1.png', 'Warm', 'warm'),
            const SizedBox(height: 20),
            buildClickableImage(
                'assets/images/skin_color2.png', 'Neutral', 'neutral'),
            const SizedBox(height: 20),
            buildClickableImage(
                'assets/images/skin_color3.png', 'Cool', 'cool'),
            const SizedBox(height: 20),
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

                  submitForm(
                    context,
                    widget.userId,
                    widget.selectionModel!, // Fixed here
                  );
                                  widget.onSubmitPressed!();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an option')));
                }
              },
              child: const Text('Submit'),
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
            duration: const Duration(milliseconds: 300),
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
                  : const ColorFilter.mode(Colors.transparent, BlendMode.clear),
              child: Image.asset(
                imagePath,
                width: 100,
                height: 100,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          optionText,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  void navigateToMain() {
    int? parsedAge = int.tryParse(widget.selectionModel!.age.toString());

    if (parsedAge != null) {
      Navigator.pushReplacementNamed(
        context,
        '/home',
        arguments: {'userId': widget.userId}, // Passing userId as an argument
      );
    } else {
      print('Invalid age entered');
    }
  }
}
