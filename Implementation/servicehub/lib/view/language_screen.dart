import 'package:flutter/material.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String selectedOption = '';

  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
    print(appState.currentIndex);
  }

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  Widget buildOption(String optionName, String secondName) {
    bool isSelected = optionName == selectedOption;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          setSelectedOption(optionName);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: Offset(0, 4))
              ]),
          child: Row(children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  optionName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Color(0xFFC84457) : Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  secondName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color:
                        isSelected ? Color(0xFFF28C9B) : Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Checkbox(
                  side: BorderSide(color: Colors.grey.shade400),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4)),
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      setSelectedOption(optionName);
                    });
                  },
                  activeColor: Color(0xFFC84457),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ApplicationState _appState = Provider.of(context, listen: true);
    final appBar = CustomAppbar(
        text: 'Language',
        showFilter: false,
        returnButton: true,
        showText: false,
        actionText: '');

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  buildOption('Français', 'French'),
                  buildOption('English', 'English'),
                  buildOption('Espanol', 'Spanish'),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: FloatingBar(),
          )

          // Positioned(
          //   bottom: 10,
          //   left: 15,
          //   right: 15,
          //   child: Container(
          //     padding: EdgeInsets.zero,
          //     margin: EdgeInsets.zero,
          //     height: 70,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey.shade400,
          //             blurRadius: 5,
          //             offset: Offset(0, 4))
          //       ],
          //     ),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(15),
          //         child:
          //             BottomBar(initialIndex: _appState.isSellerMode ? 3 : 4)),
          //   ),
          // )
        ],
      ),
    );
  }
}
