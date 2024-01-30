import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/orders/manage_orders.dart';
import 'package:servicehub/view/search_supplier_screen.dart';

class RecentCollabSearchView extends StatefulWidget {
  const RecentCollabSearchView({super.key});

  @override
  State<RecentCollabSearchView> createState() => _RecentCollabSearchViewState();
}

class _RecentCollabSearchViewState extends State<RecentCollabSearchView> {
  ManageOrders orders = ManageOrders();

  Widget serviceWidget(
      int index, DocumentSnapshot document, String name, String image) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => SearchSupplierScreen(
                          data: document,
                        ))));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                      child: image != null
                          ? CachedNetworkImage(
                              imageUrl: image,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : Image.asset(
                              'assets/avatar.png',
                              fit: BoxFit.cover,
                            )),
                ),
                const SizedBox(width: 15),
                Text(
                  name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                )
              ],
            ),
          ),
        ),
        Divider(
          endIndent: 20,
          indent: 20,
          color: Colors.grey.shade200,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently collaborated',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ))
            ],
          ),
        ),
        SingleChildScrollView(
          // width: MediaQuery.of(context).size.width,
          // color: Colors.white,
          child: Consumer<ApplicationState>(builder: (context, appState, _) {
            return appState.getUser != null
                ? FutureBuilder<List<DocumentSnapshot>>(
                    future: orders.getRecentCollabs(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                            child: Container(
                                height: 40,
                                width: 40,
                                child: CircularProgressIndicator()));
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error while loading data : ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text('No Recent Collabs'));
                      } else {
                        List<DocumentSnapshot> documents = snapshot.data!;
                        // isFavoriteList = List.filled(documents.length, false);

                        return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              DocumentSnapshot document = documents[index];
                              String name = document['company name'];
                              String image = document['logoLink'];
                              return serviceWidget(
                                  index, document, name, image);
                            });
                      }
                    })
                : Container();
          }),
        ),
      ],
    );
  }
}
