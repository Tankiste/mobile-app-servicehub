import 'package:flutter/material.dart';
import 'package:servicehub/controller/result_search_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/view/advanced_search_view.dart';
import 'package:servicehub/view/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class ResultSearchView extends StatefulWidget {
  const ResultSearchView({super.key});

  @override
  State<ResultSearchView> createState() => _ResultSearchViewState();
}

class _ResultSearchViewState extends State<ResultSearchView> {
  int selectedIndex = 0;
  List<String> buttonTexts = [
    'No filter',
    'Best rated',
    'Delivery Time',
    'Price'
  ];

  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  Widget buildButton(int index) {
    bool isSelected = selectedIndex == index;
    Color textColor = isSelected ? Color(0xFFCC344A) : Colors.black;
    Color buttonColor = isSelected ? Color(0xFFF0D0D7) : Colors.white;
    Color borderColor = isSelected ? Color(0xFFF69BA8) : Colors.grey.shade400;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: borderColor),
        ),
        child: Text(
          buttonTexts[index],
          style: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget buildContainer() {
    // Contenu du container basé sur l'index sélectionné
    String selectedButton = buttonTexts[selectedIndex];
    String containerContent = 'Contenu pour $selectedButton';

    if (selectedIndex == 0) {
      return ResultSearchListView();
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 50, top: 120),
        child: Container(
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            containerContent,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 60,
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.maybePop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios_new_rounded)),
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              SearchScreen())));
                                },
                                icon: Icon(Icons.search)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: Text(
                          'Lorem Ipsum',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 40,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: buttonTexts.length,
                          itemBuilder: (context, index) {
                            return buildButton(index);
                          },
                        ),
                      ),
                      buildContainer(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                      offset: Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BottomBar(initialIndex: 2)),
            ),
          )
        ],
      ),
    );
  }
}
