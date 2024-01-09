import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/seller/new_service_view.dart';
import 'package:servicehub/view/service_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class SupplierService extends StatefulWidget {
  final DocumentSnapshot data;
  const SupplierService({super.key, required this.data});

  @override
  State<SupplierService> createState() => _SupplierServiceState();
}

class _SupplierServiceState extends State<SupplierService> {
  Services services = Services();
  // int selectedIndex = -1;
  late List<bool> isFavoriteList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    // isFavoriteList = List.filled(0, false);
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<DocumentSnapshot> documents =
        await services.getResultServicesBySupplier();
    setState(() {
      isFavoriteList = List.generate(documents.length, (index) => false);
    });
  }

  Widget serviceWidget(
      int index, DocumentSnapshot document, double averageRating) {
    String? posterUrl = document['poster'];
    auth.User? currentUser = _auth.currentUser;

    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 20, bottom: 20),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == document['seller id']) {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: ((context) => NewServiceView(
                          newServiceId: document.id,
                          serviceType: document['type']))));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => ServiceDetailView(
                            serviceId: document.id,
                            serviceType: document['type'],
                          ))));
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ServiceDetailView(
                          serviceId: document.id,
                          serviceType: document['type'],
                        ))));
          }
        },
        child: Container(
          height: 160,
          // width: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: 175,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
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
                          'assets/digital_marketing.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 20,
                        ),
                        Text(
                          averageRating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 90),
                        // GestureDetector(
                        //     onTap: () {
                        //       // likeService(index);
                        //       setState(() {
                        //         isFavoriteList[index] = !isFavoriteList[index];
                        //       });
                        //     },
                        //     child: Icon(
                        //       Icons.favorite,
                        //       color: isFavoriteList[index]
                        //           ? Colors.red
                        //           : Colors.grey.shade300,
                        //     ))
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.clip,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          Text(
                            'From ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            'XAF${document['price']}',
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
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: FutureBuilder<List<DocumentSnapshot>>(
            future: services.getResultServicesBySupplierId(widget.data.id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Container(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Center(
                    child: Text('Error retrieving data: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text('No Service yet'),
                );
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> myservices = snapshot.data!;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: myservices.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = myservices[index];
                      return FutureBuilder<double>(
                        future: appState.calculateAverageRating(document.id),
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
                          } else if (ratingSnapshot.hasData) {
                            double averageRating = ratingSnapshot.data ?? 0;
                            return serviceWidget(
                                index, document, averageRating);
                          } else {
                            return Container();
                          }
                        },
                      );
                    });
              } else {
                return Container();
              }
            }),
      ),
    );
  }
}
