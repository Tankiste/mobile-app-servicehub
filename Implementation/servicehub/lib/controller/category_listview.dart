import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/advanced_search_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: ((context) => AdvancedSearchView())));
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 25),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/undraw_home_screen.svg',
                  width: 50,
                ),
                const SizedBox(width: 15),
                Container(
                  height: 60,
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorem ipsum dolor',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              height: 0.0,
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade500))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Divider(
          color: Colors.grey.shade200,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 6,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
