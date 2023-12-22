import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/result_search_view.dart';

class AdvancedSearchListView extends StatefulWidget {
  final String name, image, description;

  const AdvancedSearchListView(
      {super.key,
      required this.name,
      required this.image,
      required this.description});

  @override
  State<AdvancedSearchListView> createState() => _AdvancedSearchListViewState();
}

class _AdvancedSearchListViewState extends State<AdvancedSearchListView> {
  Services services = Services();
  int selectedIndex = -1;

  Widget serviceWidget(int index, String name) {
    return InkWell(
      onTap: () {
        // setState(() {
        //   selectedIndex = index;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: ((context) => ResultSearchView(
                      serviceType: name,
                    ))));
        // });
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
                  name,
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
    return SingleChildScrollView(
      // width: MediaQuery.of(context).size.width,
      // color: Colors.white,
      child: Column(
        children: [
          SvgPicture.asset(widget.image, width: 140),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, right: 40),
            child: Column(
              children: [
                Text(
                  widget.name,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(widget.description,
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
          FutureBuilder<List<DocumentSnapshot>>(
            future: services.getServiceTypesDocs(widget.name),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error in retrieving data : ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Text('No data found');
              } else {
                List<DocumentSnapshot> serviceTypes = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: serviceTypes.length,
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot serviceType = serviceTypes[index];
                      String name = serviceType['name'];
                      return serviceWidget(index, name);
                    });
              }
            },
          ),
        ],
      ),
    );
  }
}
