import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/result_search_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/service_detail_view.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Services services = Services();
  ApplicationState appState = ApplicationState();
  bool noMessage = true;
  String serviceType = "";

  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = CustomAppbar(
        text: 'My List',
        showFilter: false,
        returnButton: true,
        showText: false,
        actionText: '');

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Consumer<ApplicationState>(builder: (context, appState, _) {
              return FutureBuilder<List<DocumentSnapshot>>(
                  future: services.getLikedServices(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Container(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                            'Error retrieving liked services: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/undraw_different_love.svg',
                            width: 210,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Find all of your favorites here.',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 70,
                            width: 270,
                            child: Text(
                              'Explore the different services offered and like what most attracts you.',
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          )
                        ],
                      );
                    } else if (snapshot.hasData) {
                      List<DocumentSnapshot> favorites = snapshot.data!;
                      return SingleChildScrollView(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: favorites.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = favorites[index];
                              String? posterUrl = document['poster'];
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
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          bottom: 25,
                                          top: 20),
                                      child: InkWell(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     CupertinoPageRoute(
                                          //         builder: ((context) =>
                                          //             ServiceDetailView(
                                          //                 serviceId: document.id,
                                          //                 serviceType: widget
                                          //                     .serviceType))));
                                        },
                                        child: Container(
                                          height: 160,
                                          // width: 300,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 10,
                                                    offset: Offset(0, 5))
                                              ]),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 160,
                                                width: 175,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(15),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    15))),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  15),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  15)),
                                                  child: posterUrl != null
                                                      ? Image.network(posterUrl,
                                                          fit: BoxFit.cover,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                            value: loadingProgress
                                                                        .expectedTotalBytes !=
                                                                    null
                                                                ? loadingProgress
                                                                        .cumulativeBytesLoaded /
                                                                    loadingProgress
                                                                        .expectedTotalBytes!
                                                                : null,
                                                          ));
                                                        }, errorBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Object
                                                                      exception,
                                                                  StackTrace?
                                                                      stackTrace) {
                                                          return Icon(
                                                              Icons.error);
                                                        })
                                                      : Image.asset(
                                                          'assets/digital_marketing.png',
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, top: 8),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.star,
                                                          color: Colors
                                                              .yellow.shade700,
                                                          size: 20,
                                                        ),
                                                        Text(
                                                          averageRating
                                                              .toStringAsFixed(
                                                                  1),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.yellow
                                                                .shade700,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 90),
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
                                                        Like(
                                                            serviceId:
                                                                document.id)
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      width: 150,
                                                      child: Text(
                                                        document['title'],
                                                        maxLines: 2,
                                                        textAlign:
                                                            TextAlign.left,
                                                        style: TextStyle(
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 50,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'From ',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors.grey
                                                                  .shade400,
                                                            ),
                                                          ),
                                                          Text(
                                                            'XAF${document['price']}',
                                                            style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
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
                                },
                              );
                            }),
                      );
                    } else {
                      return Container();
                    }
                  });
            }),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: FloatingBar(),
          )
        ],
      ),
    );
  }
}
