import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class InterestListView extends StatefulWidget {
  const InterestListView({super.key});

  @override
  State<InterestListView> createState() => _InterestListViewState();
}

class _InterestListViewState extends State<InterestListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 25),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/undraw_usability_testing.svg',
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
                      Text('Lorem ipsum dolor sit amet, consectetur',
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
          height: 0,
          color: Colors.grey.shade200,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return serviceWidget(index);
              }),
        ],
      ),
    );
  }
}
