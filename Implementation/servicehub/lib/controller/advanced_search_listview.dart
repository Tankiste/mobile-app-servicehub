import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/result_search_view.dart';

class AdvancedSearchListView extends StatefulWidget {
  const AdvancedSearchListView({super.key});

  @override
  State<AdvancedSearchListView> createState() => _AdvancedSearchListViewState();
}

class _AdvancedSearchListViewState extends State<AdvancedSearchListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
          Navigator.push(context,
              CupertinoPageRoute(builder: ((context) => ResultSearchView())));
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 15),
                Text(
                  'Lorem ipsum dolor sit amet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            IconButton(
                onPressed: () {}, icon: Icon(Icons.chevron_right_outlined))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        children: [
          SvgPicture.asset('assets/undraw_specs.svg', width: 140),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: [
                Text(
                  'Lorem ipsum dolor',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text('Lorem ipsum dolor sit amet, consectetur adipiscing elit',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      overflow: TextOverflow.clip,
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade500,
                    )),
              ],
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: 6,
              itemBuilder: (BuildContext context, int index) {
                return serviceWidget(index);
              }),
        ],
      ),
    );
  }
}
