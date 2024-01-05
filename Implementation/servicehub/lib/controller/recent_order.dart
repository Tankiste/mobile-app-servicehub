import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/orders/manage_orders.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/seller/new_service_view.dart';
import 'package:servicehub/view/service_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class RecentOrderService extends StatefulWidget {
  const RecentOrderService({super.key});

  @override
  State<RecentOrderService> createState() => _RecentOrderServiceState();
}

class _RecentOrderServiceState extends State<RecentOrderService> {
  ManageOrders orders = ManageOrders();
  Services services = Services();
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

  Widget serviceWidget(int index, DocumentSnapshot document, String name,
      String logo, double averageRating) {
    String? posterUrl = document['poster'];
    String serviceType = document['type'];
    String title = document['title'];
    int price = document['price'];
    String sellerId = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
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
          height: 180,
          width: 195,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 95,
                width: 195,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: posterUrl != null
                      ? Image.network(posterUrl, fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ));
                        }, errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.error);
                        })
                      : Image.asset(
                          'assets/salle_serveur.png',
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
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: logo != null
                                ? Image.network(logo, fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                        child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ));
                                  }, errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                    return Icon(Icons.error);
                                  })
                                : Image.asset(
                                    'assets/supplier.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Level 2 Supplier',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 20,
                      width: 160,
                      child: Text(
                        title,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
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
                          width: 20,
                        ),
                        Text(
                          'From ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade400,
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
    return Container(
      height: 205,
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
                    return Text('Error while loading data : ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Recent Orders'));
                  } else {
                    List<DocumentSnapshot> documents = snapshot.data!;
                    // isFavoriteList = List.filled(documents.length, false);

                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = documents[index];
                          String supplierId = document['seller id'];
                          return FutureBuilder<double>(
                            future:
                                appState.calculateAverageRating(document.id),
                            builder: (context, ratingSnapshot) {
                              if (ratingSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator()));
                              } else if (ratingSnapshot.hasError) {
                                return Text('Error calculating average rating');
                              } else {
                                double averageRating = ratingSnapshot.data ?? 0;
                                return FutureBuilder<UserData?>(
                                    future: services.getSupplier(supplierId),
                                    builder: (context, supplierSnapshot) {
                                      if (supplierSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                            child: Container(
                                                height: 40,
                                                width: 40,
                                                child:
                                                    CircularProgressIndicator()));
                                      } else if (supplierSnapshot.hasError) {
                                        return Text(
                                            'Error getting supplier info');
                                      } else {
                                        UserData? userData =
                                            supplierSnapshot.data;
                                        if (userData != null) {
                                          String name = userData.username ?? '';
                                          String logo = userData.logo ?? '';
                                          return serviceWidget(index, document,
                                              name, logo, averageRating);
                                        } else {
                                          return Text('Supplier data is null');
                                        }
                                      }
                                    });
                              }
                            },
                          );
                        });
                  }
                })
            : Container();
      }),
    );
  }
}
