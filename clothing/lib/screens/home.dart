import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Vogue Voyage'),
        ),
        body: const MyCarousels(),
      ),
    );
  }
}

class MyCarousels extends StatelessWidget {
  const MyCarousels({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: CarouselWithButton(initialItems: const ['Image 1', 'Image 2', 'Image 3', 'Image 4']),
        ),
        Expanded(
          child: CarouselWithButton(initialItems: const ['Image 5', 'Image 6', 'Image 7', 'Image 8']),
        ),
        Expanded(
          child: CarouselWithButton(initialItems: const ['Image 9', 'Image 10', 'Image 11', 'Image 12']),
        ),
        Expanded(
          child: CarouselWithButton(initialItems: const ['Image 13', 'Image 14', 'Image 15', 'Image 16']),
        ),
      ],
    );
  }
}

class CarouselWithButton extends StatefulWidget {
  final List<String> initialItems;

  const CarouselWithButton({super.key, required this.initialItems});

  @override
  _CarouselWithButtonState createState() => _CarouselWithButtonState();
}

class _CarouselWithButtonState extends State<CarouselWithButton> {
  late List<String> items;

  @override
  void initState() {
    super.initState();
    items = widget.initialItems;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 7,
          child: MyCarousel(items: items),
        ),
        Expanded(
          flex: 3,
          child: ElevatedButton(
            onPressed: () => _showPopupMenu(context),
            child: const Text('Change Images'),
          ),
        ),
      ],
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final List<String> options = ['Set 1', 'Set 2', 'Set 3', 'Set 4'];

    final selectedOption = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Image Set'),
          children: options
              .map((option) => SimpleDialogOption(
                    onPressed: () {
                      Navigator.pop(context, option);
                    },
                    child: Text(option),
                  ))
              .toList(),
        );
      },
    );

    if (selectedOption != null) {
      // Update the items list based on the selected option
      setState(() {
        switch (selectedOption) {
          case 'Set 1':
            items = ['Image A', 'Image B', 'Image C', 'Image D'];
            break;
          case 'Set 2':
            items = ['Image E', 'Image F', 'Image G', 'Image H'];
            break;
          case 'Set 3':
            items = ['Image I', 'Image J', 'Image K', 'Image L'];
            break;
          case 'Set 4':
            items = ['Image M', 'Image N', 'Image O', 'Image P'];
            break;
        }
      });
    }
  }
}

class MyCarousel extends StatelessWidget {
  final List<String> items;

  MyCarousel({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: PageController(viewportFraction: 0.8),
      itemCount: items.length * 100,
      itemBuilder: (context, index) {
        final item = items[index % items.length];
        return buildItem(item);
      },
    );
  }

  Widget buildItem(String item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        color: Colors.blue,
        child: Center(
          child: Text(
            item,
            style: const TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
