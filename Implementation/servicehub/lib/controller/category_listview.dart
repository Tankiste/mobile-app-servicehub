import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/advanced_search_view.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({super.key});

  @override
  State<CategoryListView> createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> {
  int selectedIndex = -1;
  Services services = Services();

  Widget serviceWidget(
      int index, String name, String image, String description) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // setState(() {
            //   selectedIndex = index;
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => AdvancedSearchView())));
            // });
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 25),
            child: Row(
              children: [
                SvgPicture.asset(
                  image,
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
                        name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(description,
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
    return SingleChildScrollView(
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getCategoriesDocs(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error while retrieving data : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text('No data found');
            } else {
              List<DocumentSnapshot> categories = snapshot.data!;

              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot category = categories[index];
                    String name = category['name'];
                    String image = category['image'];
                    String description = category['description'];
                    return serviceWidget(index, name, image, description);
                  });
            }
          }),
    );
  }
}
