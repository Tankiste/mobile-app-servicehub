import 'package:flutter/material.dart';
import 'package:servicehub/controller/advanced_search_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class AdvancedSearchView extends StatefulWidget {
  final String name, image, description;
  const AdvancedSearchView(
      {super.key,
      required this.name,
      required this.image,
      required this.description});

  @override
  State<AdvancedSearchView> createState() => _AdvancedSearchViewState();
}

class _AdvancedSearchViewState extends State<AdvancedSearchView> {
  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
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
                      const SizedBox(height: 10),
                      AdvancedSearchListView(
                        name: widget.name,
                        image: widget.image,
                        description: widget.description,
                      ),
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
          //         child: BottomBar(initialIndex: 2)),
          //   ),
          // )
        ],
      ),
    );
  }
}
