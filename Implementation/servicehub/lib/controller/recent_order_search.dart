import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/orders/manage_orders.dart';
import 'package:servicehub/view/seller/new_service_view.dart';
import 'package:servicehub/view/service_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class RecentOrderSearchView extends StatefulWidget {
  final bool showText;

  const RecentOrderSearchView({super.key, required this.showText});

  @override
  State<RecentOrderSearchView> createState() => _RecentOrderSearchViewState();
}

class _RecentOrderSearchViewState extends State<RecentOrderSearchView> {
  ManageOrders orders = ManageOrders();
  late List<DocumentSnapshot> documents;
  late List<bool> isFavoriteList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    documents = await orders.getRecentOrders();
    isFavoriteList = List.generate(documents.length, (index) => false);

    for (int i = 0; i < documents.length; i++) {
      bool isLiked = await appState.checkLikeStatus(documents[i].id);
      setState(() {
        isFavoriteList[i] = isLiked;
      });
    }
  }

  Widget serviceWidget(
      int index, DocumentSnapshot document, double averageRating) {
    String? posterUrl = document['poster'];
    String serviceType = document['type'];
    String title = document['title'];
    int price = document['price'];
    String sellerId = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == sellerId) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: ((context) => NewServiceView(
                          newServiceId: document.id,
                          serviceType: document['type']))));
            } else {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: ((context) => ServiceDetailView(
                          serviceId: document.id, serviceType: serviceType))));
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => ServiceDetailView(
                        serviceId: document.id, serviceType: serviceType))));
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
          }
        },
        child: Container(
          height: 195,
          width: 155,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade500,
                    blurRadius: 10,
                    offset: Offset(0, 4))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: 155,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: posterUrl != null
                      ? CachedNetworkImage(
                          imageUrl: posterUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        )
                      : Image.asset(
                          'assets/floeurs.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 17,
                        ),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      height: 44,
                      width: 120,
                      child: Text(
                        title,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          overflow: TextOverflow.clip,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          Text(
                            'From ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade300,
                            ),
                          ),
                          Text(
                            'XAF ${price.toString()}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showText)
          Padding(
            padding: const EdgeInsets.only(
              left: 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recently ordered services',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
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
        Container(
          height: 260,
          color: Colors.transparent,
          child: Consumer<ApplicationState>(builder: (context, appState, _) {
            return appState.getUser != null
                ? FutureBuilder<List<DocumentSnapshot>>(
                    future: orders.getRecentOrders(),
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
                        return Center(child: Text('No Recent Orders'));
                      } else {
                        List<DocumentSnapshot> documents = snapshot.data!;
                        // isFavoriteList = List.filled(documents.length, false);

                        return Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: documents.length,
                              itemBuilder: (BuildContext context, int index) {
                                DocumentSnapshot document = documents[index];
                                return FutureBuilder<double>(
                                  future: appState
                                      .calculateAverageRating(document.id),
                                  builder: (context, ratingSnapshot) {
                                    if (ratingSnapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: Container(
                                              height: 40,
                                              width: 40,
                                              child:
                                                  CircularProgressIndicator()));
                                    } else if (ratingSnapshot.hasError) {
                                      return Text(
                                          'Error calculating average rating');
                                    } else {
                                      double averageRating =
                                          ratingSnapshot.data ?? 0;
                                      return serviceWidget(
                                          index, document, averageRating);
                                    }
                                  },
                                );
                              }),
                        );
                      }
                    })
                : Container();
          }),
        ),
      ],
    );
  }
}
