import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/seller/new_service_view.dart';
import 'package:servicehub/view/service_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class RelatedServiceListView extends StatefulWidget {
  final serviceType;
  final bool showText;
  final serviceId;

  const RelatedServiceListView(
      {super.key,
      required this.showText,
      required this.serviceType,
      required this.serviceId});

  @override
  State<RelatedServiceListView> createState() => _RelatedServiceListViewState();
}

class _RelatedServiceListViewState extends State<RelatedServiceListView> {
  Services services = Services();
  int selectedIndex = -1;
  late List<bool> isFavoriteList;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    // isFavoriteList = List.filled(0, false);
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<DocumentSnapshot> documents =
        await services.getResultServicesExcludingCurrentService(
            widget.serviceType, widget.serviceId);
    setState(() {
      isFavoriteList = List.generate(documents.length, (index) => false);
    });
  }

  Widget serviceWidget(int index, String sellerUid, String name, String image,
      int price, String type, String newId) {
    auth.User currentUser = _auth.currentUser!;
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          // setState(() {
          //   selectedIndex = index;
          // });
          if (currentUser.uid == sellerUid) {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => NewServiceView(
                        newServiceId: newId, serviceType: type))));
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => ServiceDetailView(
                          serviceId: newId,
                          serviceType: type,
                        ))));
          }
        },
        child: Container(
          height: 195,
          width: 155,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
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
                  child: image != null
                      ? Image.network(image, fit: BoxFit.cover, loadingBuilder:
                          (BuildContext context, Widget child,
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
                          '5.0',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 75,
                        ),
                        // IconButton(
                        //     onPressed: () {
                        //       setState(() {
                        //         isFavoriteList[index] = !isFavoriteList[index];
                        //       });
                        //     },
                        //     icon: Icon(
                        //       Icons.favorite,
                        //       color: isFavoriteList[index]
                        //           ? Colors.red
                        //           : Colors.grey.shade300,
                        //     )),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                isFavoriteList[index] = !isFavoriteList[index];
                              });
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isFavoriteList[index]
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        name,
                        textAlign: TextAlign.left,
                        maxLines: 2,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
      height: 215,
      color: Colors.white,
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getResultServicesExcludingCurrentService(
              widget.serviceType, widget.serviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error while retrieving data : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No related service exists'));
            } else {
              List<DocumentSnapshot> related_services = snapshot.data!;
              return ListView.builder(
                  // shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: related_services.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot related_service = related_services[index];
                    String name = related_service['title'];
                    String image = related_service['poster'];
                    int price = related_service['price'];
                    String type = related_service['type'];
                    String sellerUid = related_service['seller id'];
                    String newId = related_service.id;
                    return serviceWidget(
                        index, sellerUid, name, image, price, type, newId);
                  });
            }
          }),
    );
  }
}
