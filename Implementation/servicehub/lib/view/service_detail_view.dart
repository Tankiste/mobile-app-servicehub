import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/controller/related_service_listview.dart';
import 'package:servicehub/controller/review_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/chat_screen.dart';
import 'package:servicehub/view/login.dart';
import 'package:servicehub/view/order_review.dart';
import 'package:servicehub/view/result_search_view.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:like_button/like_button.dart';
import 'package:servicehub/view/reviews_screen.dart';

class ServiceDetailView extends StatefulWidget {
  final String serviceId;
  final serviceType;
  const ServiceDetailView(
      {super.key, required this.serviceId, required this.serviceType});

  @override
  State<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<ServiceDetailView> {
  // bool _isFavorite = false;
  TextEditingController reviewController = TextEditingController();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  int _rating = 0;
  ServiceData? serviceData;
  UserData? supplierData;
  Services _services = Services();
  late List<DocumentSnapshot> reviews;
  late int totalLike;
  bool isLoading = false;
  // ApplicationState _appState = ApplicationState();

  @override
  void initState() {
    fetchServiceDetails();
    // updateData();
    loadReviews();
    Provider.of<ApplicationState>(context, listen: false)
        .totalLikes(widget.serviceId);
    // totalLikes();
    super.initState();
  }

  // Future<void> totalLikes() async {
  //   totalLike = await _appState.totalLikes(widget.serviceId);
  // }

  // updateData() async {
  //   ApplicationState appState = Provider.of(context, listen: false);
  //   await appState.refreshUser();
  // }

  Future<void> fetchServiceDetails() async {
    ServiceData? data = await _services.getServiceById(widget.serviceId);
    if (data != null) {
      setState(() {
        serviceData = data;
      });
      UserData? userData = await _services.getSupplier(serviceData!.sellerUid);
      if (userData != null) {
        setState(() {
          supplierData = userData;
        });
      } else
        return null;
    } else
      return null;
  }

  Widget buildSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 72,
                decoration: BoxDecoration(
                  color: Colors.grey.shade500,
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'What is your rate?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                    5,
                    (index) => Padding(
                          padding: const EdgeInsets.only(right: 3),
                          child: SizedBox(
                            width: 45,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  _rating = index + 1;
                                });
                              },
                              iconSize: 42,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                index < _rating
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.orange.shade900,
                              ),
                            ),
                          ),
                        )),
              ),
              const SizedBox(height: 25),
              SizedBox(
                height: 50,
                width: 237,
                child: Text(
                  'Please leave your opinion about the service',
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.clip),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Container(
                  height: 165,
                  decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.grey.shade300,
                      )),
                  child: TextFormField(
                    controller: reviewController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        hintText: "Your review...",
                        contentPadding:
                            EdgeInsets.only(left: 10, right: 5, bottom: 5),
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w300,
                            fontSize: 15),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          String result = await _services.addReview(
                              widget.serviceId, reviewController.text, _rating);
                          final provider = Provider.of<ApplicationState>(
                              context,
                              listen: false);
                          double averageRating = await provider
                              .calculateAverageRating(widget.serviceId);
                          await _services.updateAverageRate(
                              widget.serviceId, averageRating);
                          if (result == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Review created successfully')),
                            );
                          } else if (result == 'exists') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Review updated successfully')),
                            );
                          }
                          setState(
                            () {
                              isLoading = false;
                            },
                          );
                          Navigator.pop(context);
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: ((context) =>
                          //             RequestSend())));
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC84457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 90, right: 90, top: 15, bottom: 15),
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Send Review',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gilroy'),
                          ),
                  )),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> loadReviews() async {
    try {
      List<DocumentSnapshot> fetchedReviews =
          await _services.getReviewsByServices(widget.serviceId);
      setState(() {
        reviews = fetchedReviews;
      });
    } catch (err) {
      print('Error fetching reviews: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? posterUrl = serviceData?.poster;
    String? logoLink = supplierData?.logo;
    auth.User? currentUser = _auth.currentUser;

    return Scaffold(
      body: (serviceData == null || supplierData == null)
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                    child: Column(children: [
                  Stack(
                    children: [
                      Container(
                          height: 340,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              // image: DecorationImage(
                              //     image: AssetImage('assets/video-production.png'),
                              //     fit: BoxFit.cover),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
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
                                    'assets/video-production.png',
                                    fit: BoxFit.cover,
                                  ),
                          )),
                      Positioned(
                          left: 20,
                          top: 50,
                          child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: IconButton(
                                      padding: EdgeInsets.only(right: 5),
                                      onPressed: () {
                                        Navigator.maybePop(context);
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: ((context) =>
                                        //             ResultSearchView(
                                        //                 serviceType: widget
                                        //                     .serviceType))));
                                      },
                                      icon: Icon(
                                          Icons.arrow_back_ios_new_rounded)),
                                ),
                                const SizedBox(
                                  width: 280,
                                ),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white),
                                  child: IconButton(
                                      padding:
                                          EdgeInsets.only(right: 1, bottom: 3),
                                      onPressed: () {},
                                      icon: Icon(Icons.ios_share_rounded)),
                                ),
                              ]))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 290,
                                        child: Text(
                                          serviceData!.title,
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 32,
                                            height: 32,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: ClipOval(
                                              child: logoLink != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: logoLink,
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) =>
                                                              Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      ),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(Icons.error),
                                                    )
                                                  : Image.asset(
                                                      "assets/supplier.png",
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(width: 7),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                supplierData!.username,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              Text(
                                                'Level 2 Supplier',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade400,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // const SizedBox(
                                  //   width: 60,
                                  // ),
                                  Consumer<ApplicationState>(
                                      builder: (context, appState, _) {
                                    return Row(
                                      children: [
                                        Text(appState.totalLike.toString()),
                                        Like(serviceId: widget.serviceId),
                                      ],
                                    );
                                  }),
                                  // LikeButton(
                                  //   // onTap: (isLiked) {

                                  //   // },
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   mainAxisAlignment: MainAxisAlignment.start,
                                  // )
                                  // IconButton(
                                  //     onPressed: () {
                                  //       setState(() {
                                  //         _isFavorite = !_isFavorite;
                                  //       });
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.favorite,
                                  //       size: 33,
                                  //       color: _isFavorite
                                  //           ? Colors.red
                                  //           : Colors.grey.shade300,
                                  //     ))
                                ],
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Text(
                                'Description',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                serviceData!.description,
                                maxLines: 7,
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    overflow: TextOverflow.clip,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey.shade500),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Delivary Time',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    serviceData!.delivaryTime,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Review',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('reviews')
                                      .where('service Id',
                                          isEqualTo: widget.serviceId)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data!.docs.isEmpty) {
                                      return Center(
                                          child: Text('Not yet rated'));
                                    }
                                    if (snapshot.hasData) {
                                      double totalRating = 0;
                                      for (var doc in snapshot.data!.docs) {
                                        totalRating +=
                                            (doc['rating'] as int).toDouble();
                                      }
                                      double averageRating = totalRating /
                                          snapshot.data!.docs.length;
                                      return Row(
                                        children: [
                                          SizedBox(
                                            // width: 50,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: List.generate(
                                                  5,
                                                  (index) => Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(right: 3),
                                                        child: SizedBox(
                                                          width: 17,
                                                          child: Icon(
                                                            index <
                                                                    averageRating
                                                                        .roundToDouble()
                                                                ? Icons.star
                                                                : Icons
                                                                    .star_border,
                                                            color: Colors.yellow
                                                                .shade700,
                                                            size: 20,
                                                          ),
                                                        ),
                                                      )),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            averageRating.toStringAsFixed(1),
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                              const SizedBox(
                                height: 3,
                              ),
                              Row(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${reviews.length} Reviews',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: ((context) =>
                                                    ReviewsScreen(
                                                        serviceId: widget
                                                            .serviceId))));
                                      },
                                      child: Text(
                                        'See All',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFFC84457),
                                        ),
                                      ))
                                ],
                              ),
                              ReviewListView(
                                serviceId: widget.serviceId,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: ((context) {
                                              return buildSheet();
                                            }));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.penToSquare,
                                        size: 20,
                                      )),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: ((context) {
                                              return buildSheet();
                                            }));
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border: Border.all(
                                                color: Colors.grey.shade300)),
                                        child: Text('Write a review',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Consumer<ApplicationState>(
                                  builder: (context, appState, _) {
                                return ElevatedButton(
                                    onPressed: () {
                                      if (appState.getUser != null) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    OrderReview(
                                                      serviceId:
                                                          widget.serviceId,
                                                    ))));
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    LoginPage())));
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFC84457),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 58,
                                          right: 58,
                                          top: 15,
                                          bottom: 15),
                                      child: Text(
                                        'Continue (XAF ${serviceData!.price})',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Gilroy'),
                                      ),
                                    ));
                              }),
                              // // const SizedBox(
                              // //   height: 15,
                              // // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Related services',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                RelatedServiceListView(
                                    showText: false,
                                    serviceType: widget.serviceType,
                                    serviceId: widget.serviceId),
                              ]),
                        )
                        // const SizedBox(height: 15),
                      ],
                    ),
                  )
                ])),
                Positioned(
                    bottom: 10,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(5, 5, 13, 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade400,
                              blurRadius: 10,
                              offset: Offset(0, 4))
                        ],
                      ),
                      child: InkWell(
                        onTap: () {
                          if (currentUser != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatScreen(
                                        receiverData: supplierData!)));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => LoginPage())));
                            // Navigator.push(context,
                            //     CupertinoPageRoute(builder: ((context) => LoginPage())));
                          }
                        },
                        child: Row(children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: logoLink != null
                                  ? CachedNetworkImage(
                                      imageUrl: logoLink,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Image.asset(
                                      "assets/supplier.png",
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Text(
                            'Chat',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          )
                        ]),
                      ),
                    ))
              ],
            ),
    );
  }
}
