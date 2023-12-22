import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyInterestWidget extends StatefulWidget {
  const MyInterestWidget({super.key});

  @override
  State<MyInterestWidget> createState() => _MyInterestWidgetState();
}

class _MyInterestWidgetState extends State<MyInterestWidget> {
  final MyInterestStateProvider _stateProvider = MyInterestStateProvider();
  Color _borderColor = Colors.grey.shade100;
  Color _selectedBorderColor = Color(0xFFC84457);
  Map<int, Color> _borderColors = {};
  // bool _isSelect = false;
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
              _borderColors[selectedIndex] =
                  _borderColors[selectedIndex] == _selectedBorderColor
                      ? _borderColor
                      : _selectedBorderColor;
            });
            _stateProvider.updateAtLeastOneInkwellSelected();
          },
          child: Container(
            height: 157,
            width: 160,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: _borderColors[index] ?? _borderColor,
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
                ]),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 60,
                  child: SvgPicture.asset(
                    'assets/undraw_progressive_app.svg',
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Divider(thickness: 1, color: Colors.grey.shade100),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  'Lorem ipsum',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
            childAspectRatio: 1.0),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          _borderColors[index] = _borderColors[index] ?? Colors.grey.shade100;
          return serviceWidget(index);
        });
  }
}

class MyInterestStateProvider extends ChangeNotifier {
  bool atLeastOneInkwellSelected = false;

  void updateAtLeastOneInkwellSelected() {
    atLeastOneInkwellSelected = true;
    notifyListeners();
  }
}
