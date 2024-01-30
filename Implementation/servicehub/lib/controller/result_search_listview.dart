import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/seller/new_service_view.dart';
import 'package:servicehub/view/service_detail_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cached_network_image/cached_network_image.dart';

class ResultSearchListView extends StatefulWidget {
  final String serviceType;
  const ResultSearchListView({super.key, required this.serviceType});

  @override
  State<ResultSearchListView> createState() => _ResultSearchListViewState();
}

class _ResultSearchListViewState extends State<ResultSearchListView> {
  // int selectedIndex = -1;
  // bool isFavorite = false;
  Services services = Services();
  // late List<bool> isFavoriteList;
  late List<DocumentSnapshot> documents;
  late List<bool> isLikedList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    documents = await services.getResultServices(widget.serviceType);
    isLikedList = List.generate(documents.length, (index) => false);

    for (int i = 0; i < documents.length; i++) {
      bool isLiked = await appState.checkLikeStatus(documents[i].id);
      setState(() {
        isLikedList[i] = isLiked;
      });
    }
  }

  Widget serviceWidget(
      DocumentSnapshot document, int index, double averageRating) {
    String? posterUrl = document['poster'];
    String sellerUid = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == sellerUid) {
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
                          serviceId: document.id,
                          serviceType: widget.serviceType))));
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => ServiceDetailView(
                        serviceId: document.id,
                        serviceType: widget.serviceType))));
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
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
                        // IconButton(
                        //     onPressed: () {
                        //       likeService();
                        //     },
                        //     icon: Icon(
                        //       Icons.favorite,
                        //       color: isFavorite
                        //           ? Colors.red
                        //           : Colors.grey.shade300,
                        //     )),
                        // GestureDetector(
                        //   onTap: () async {
                        //     setState(() {
                        //       isLikedList[index] = !isLikedList[index];
                        //     });

                        //     await services.toggleLike(document.id);
                        //     await appState.checkLikeStatus(document.id);
                        //   },
                        //   child: Icon(
                        //     isLikedList[index]
                        //         ? Icons.favorite
                        //         : Icons.favorite_border_outlined,
                        //     color: isLikedList[index]
                        //         ? Colors.red
                        //         : Colors.grey.shade500,
                        //   ),
                        // ),
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
                            'XAF ${document['price']}',
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
    return SingleChildScrollView(
      // color: Colors.white,
      child: Consumer<ApplicationState>(builder: (context, appState, _) {
        return FutureBuilder<List<DocumentSnapshot>>(
            future: services.getResultServices(widget.serviceType),
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
                return Center(child: Text('No data found'));
              } else {
                List<DocumentSnapshot> documents = snapshot.data!;
                // isFavoriteList = List.filled(documents.length, false);

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = documents[index];
                      return FutureBuilder<double>(
                        future: appState.calculateAverageRating(document.id),
                        builder: (context, ratingSnapshot) {
                          if (ratingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                              height: 40,
                              width: 40,
                              // child: CircularProgressIndicator()
                            ));
                          } else if (ratingSnapshot.hasError) {
                            return Text('Error calculating average rating');
                          } else {
                            double averageRating = ratingSnapshot.data ?? 0;
                            return serviceWidget(
                                document, index, averageRating);
                          }
                        },
                      );
                    });
              }
            });
      }),
    );
  }
}

class SearchByAverageListView extends StatefulWidget {
  final String serviceType;
  const SearchByAverageListView({super.key, required this.serviceType});

  @override
  State<SearchByAverageListView> createState() =>
      _SearchByAverageListViewState();
}

class _SearchByAverageListViewState extends State<SearchByAverageListView> {
  // int selectedIndex = -1;
  // bool isFavorite = false;
  Services services = Services();
  // late List<bool> isFavoriteList;
  late List<DocumentSnapshot> documents;
  late List<bool> isLikedList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    documents =
        await services.getResultServicesByAverageRate(widget.serviceType);
    isLikedList = List.generate(documents.length, (index) => false);

    for (int i = 0; i < documents.length; i++) {
      bool isLiked = await appState.checkLikeStatus(documents[i].id);
      setState(() {
        isLikedList[i] = isLiked;
      });
    }
  }

  Widget serviceWidget(
      DocumentSnapshot document, int index, double averageRating) {
    String? posterUrl = document['poster'];
    String sellerUid = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == sellerUid) {
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
                          serviceId: document.id,
                          serviceType: widget.serviceType))));
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => ServiceDetailView(
                        serviceId: document.id,
                        serviceType: widget.serviceType))));
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
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
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
                            'XAF ${document['price']}',
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
    return SingleChildScrollView(
      // color: Colors.white,
      child: Consumer<ApplicationState>(builder: (context, appState, _) {
        return FutureBuilder<List<DocumentSnapshot>>(
            future: services.getResultServicesByAverageRate(widget.serviceType),
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
                return Center(child: Text('No data found'));
              } else {
                List<DocumentSnapshot> documents = snapshot.data!;
                // isFavoriteList = List.filled(documents.length, false);

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = documents[index];
                      return FutureBuilder<double>(
                        future: appState.calculateAverageRating(document.id),
                        builder: (context, ratingSnapshot) {
                          if (ratingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                              height: 40,
                              width: 40,
                              // child: CircularProgressIndicator()
                            ));
                          } else if (ratingSnapshot.hasError) {
                            return Text('Error calculating average rating');
                          } else {
                            double averageRating = ratingSnapshot.data ?? 0;
                            return serviceWidget(
                                document, index, averageRating);
                          }
                        },
                      );
                    });
              }
            });
      }),
    );
  }
}

class SearchByPriceListView extends StatefulWidget {
  final String serviceType;
  const SearchByPriceListView({super.key, required this.serviceType});

  @override
  State<SearchByPriceListView> createState() => _SearchByPriceListViewState();
}

class _SearchByPriceListViewState extends State<SearchByPriceListView> {
  // int selectedIndex = -1;
  // bool isFavorite = false;
  Services services = Services();
  // late List<bool> isFavoriteList;
  late List<DocumentSnapshot> documents;
  late List<bool> isLikedList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    documents = await services.getResultServicesByPrice(widget.serviceType);
    isLikedList = List.generate(documents.length, (index) => false);

    for (int i = 0; i < documents.length; i++) {
      bool isLiked = await appState.checkLikeStatus(documents[i].id);
      setState(() {
        isLikedList[i] = isLiked;
      });
    }
  }

  Widget serviceWidget(
      DocumentSnapshot document, int index, double averageRating) {
    String? posterUrl = document['poster'];
    String sellerUid = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == sellerUid) {
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
                          serviceId: document.id,
                          serviceType: widget.serviceType))));
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => ServiceDetailView(
                        serviceId: document.id,
                        serviceType: widget.serviceType))));
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
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
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
                            'XAF ${document['price']}',
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
    return SingleChildScrollView(
      // color: Colors.white,
      child: Consumer<ApplicationState>(builder: (context, appState, _) {
        return FutureBuilder<List<DocumentSnapshot>>(
            future: services.getResultServicesByPrice(widget.serviceType),
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
                return Center(child: Text('No data found'));
              } else {
                List<DocumentSnapshot> documents = snapshot.data!;
                // isFavoriteList = List.filled(documents.length, false);

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = documents[index];
                      return FutureBuilder<double>(
                        future: appState.calculateAverageRating(document.id),
                        builder: (context, ratingSnapshot) {
                          if (ratingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                              height: 40,
                              width: 40,
                              // child: CircularProgressIndicator()
                            ));
                          } else if (ratingSnapshot.hasError) {
                            return Text('Error calculating average rating');
                          } else {
                            double averageRating = ratingSnapshot.data ?? 0;
                            return serviceWidget(
                                document, index, averageRating);
                          }
                        },
                      );
                    });
              }
            });
      }),
    );
  }
}

class SearchByDateListView extends StatefulWidget {
  final String serviceType;
  const SearchByDateListView({super.key, required this.serviceType});

  @override
  State<SearchByDateListView> createState() => _SearchByDateListViewState();
}

class _SearchByDateListViewState extends State<SearchByDateListView> {
  // int selectedIndex = -1;
  // bool isFavorite = false;
  Services services = Services();
  // late List<bool> isFavoriteList;
  late List<DocumentSnapshot> documents;
  late List<bool> isLikedList;
  ApplicationState appState = ApplicationState();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    documents = await services.getResultServicesByPrice(widget.serviceType);
    isLikedList = List.generate(documents.length, (index) => false);

    for (int i = 0; i < documents.length; i++) {
      bool isLiked = await appState.checkLikeStatus(documents[i].id);
      setState(() {
        isLikedList[i] = isLiked;
      });
    }
  }

  Widget serviceWidget(
      DocumentSnapshot document, int index, double averageRating) {
    String? posterUrl = document['poster'];
    String sellerUid = document['seller id'];
    auth.User? currentUser = _auth.currentUser;
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: InkWell(
        onTap: () {
          if (currentUser != null) {
            if (currentUser.uid == sellerUid) {
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
                          serviceId: document.id,
                          serviceType: widget.serviceType))));
            }
          } else {
            Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: ((context) => ServiceDetailView(
                        serviceId: document.id,
                        serviceType: widget.serviceType))));
            // Navigator.push(context,
            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
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
                        Like(serviceId: document.id)
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 50,
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
                            'XAF ${document['price']}',
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
    return SingleChildScrollView(
      // color: Colors.white,
      child: Consumer<ApplicationState>(builder: (context, appState, _) {
        return FutureBuilder<List<DocumentSnapshot>>(
            future: services.getResultServicesByDate(widget.serviceType),
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
                return Center(child: Text('No data found'));
              } else {
                List<DocumentSnapshot> documents = snapshot.data!;
                // isFavoriteList = List.filled(documents.length, false);

                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: documents.length,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      DocumentSnapshot document = documents[index];
                      return FutureBuilder<double>(
                        future: appState.calculateAverageRating(document.id),
                        builder: (context, ratingSnapshot) {
                          if (ratingSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Container(
                              height: 40,
                              width: 40,
                              // child: CircularProgressIndicator()
                            ));
                          } else if (ratingSnapshot.hasError) {
                            return Text('Error calculating average rating');
                          } else {
                            double averageRating = ratingSnapshot.data ?? 0;
                            return serviceWidget(
                                document, index, averageRating);
                          }
                        },
                      );
                    });
              }
            });
      }),
    );
  }
}
