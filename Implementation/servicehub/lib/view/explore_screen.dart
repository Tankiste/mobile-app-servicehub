import 'package:flutter/material.dart';
import 'package:servicehub/controller/category_listview.dart';
import 'package:servicehub/controller/interest_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/view/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  String selectedOption = 'Categories';

  @override
  void initState() {
    super.initState();
    updateData();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      if (option == 'Categories') {
        _animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(_controller);
      } else {
        _animation = Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(_controller);
      }
      _controller.forward(from: 0.0);
    });
  }

  Widget buildDivider() {
    return SlideTransition(
      position: _animation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Divider(
          height: 0,
          thickness: 2.0,
          color: const Color(0xFFC84457),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (selectedOption == 'Categories') {
      return CategoryListView();
    } else {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Interests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFFC84457)),
                    ))
              ],
            ),
          ),
          InterestListView()
        ],
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
              padding: const EdgeInsets.only(top: 60, bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) => SearchScreen())));
                            },
                            icon: Icon(Icons.search)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: () => _updateSelectedOption('Categories'),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: selectedOption == 'Categories'
                                ? Color(0xFFC84457)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _updateSelectedOption('Interest'),
                        child: Text(
                          'Interest',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: selectedOption == 'Interest'
                                ? Color(0xFFC84457)
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  buildDivider(),
                  buildContent(),
                ],
              ),
            ),
          ),
        ),
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
        //         child: BottomBar(initialIndex: 2)),
        //   ),
        // )
      ],
    ));
  }
}
