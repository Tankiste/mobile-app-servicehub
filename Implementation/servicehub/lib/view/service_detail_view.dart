import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/controller/review_listview.dart';
import 'package:servicehub/view/result_search_view.dart';
import 'package:like_button/like_button.dart';
import 'package:servicehub/view/reviews_screen.dart';

class ServiceDetailView extends StatefulWidget {
  const ServiceDetailView({super.key});

  @override
  State<ServiceDetailView> createState() => _ServiceDetailViewState();
}

class _ServiceDetailViewState extends State<ServiceDetailView> {
  // bool _isFavorite = false;
  int _rating = 0;

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
                  onPressed: () {
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
                  child: const Padding(
                    padding: EdgeInsets.only(
                        left: 90, right: 90, top: 15, bottom: 15),
                    child: Text(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Column(children: [
            Container(
                height: 340,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/video-production.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                child: Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 60),
                    child: Stack(
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultSearchView()));
                                    },
                                    icon:
                                        Icon(Icons.arrow_back_ios_new_rounded)),
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
                            ])
                      ],
                    ))),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lorem ipsum dolor',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration:
                                          BoxDecoration(shape: BoxShape.circle),
                                      child: ClipOval(
                                          child: Image.asset(
                                        'assets/supplier.png',
                                        fit: BoxFit.cover,
                                      )),
                                    ),
                                    const SizedBox(width: 7),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Binho',
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
                            const SizedBox(
                              width: 60,
                            ),
                            LikeButton(
                              // onTap: (isLiked) {

                              // },
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                            )
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
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sed dolor non turpis euismod convallis. Pellentesque lacinia mattis aliquet. Phasellus vitae dolor in ipsumt. Aliquam et elit auctor, semper justo vel, sagittis massa.',
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
                        Text(
                          'Review',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              // width: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  if (index < 3) {
                                    return Icon(Icons.star_rounded,
                                        size: 23,
                                        color: Colors.yellow.shade700);
                                  } else if (index == 3) {
                                    return Icon(Icons.star_half_rounded,
                                        size: 23,
                                        color: Colors.yellow.shade700);
                                  } else {
                                    return Icon(Icons.star_outline_rounded,
                                        size: 23,
                                        color: Colors.yellow.shade700);
                                  }
                                }),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              '3.6',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '32 Reviews',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                          builder: ((context) =>
                                              ReviewsScreen())));
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
                        ReviewListView(),
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
                                      borderRadius: BorderRadius.circular(20),
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
                        ElevatedButton(
                            onPressed: () {
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
                            child: const Padding(
                              padding: EdgeInsets.only(
                                  left: 75, right: 80, top: 15, bottom: 15),
                              child: Text(
                                'Continue (€57.63)',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Gilroy'),
                              ),
                            )),
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
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          RecentOrderSearchView(
                            showText: false,
                          ),
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
                  onTap: () {},
                  child: Row(children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                          child: Image.asset(
                        'assets/supplier.png',
                        fit: BoxFit.cover,
                      )),
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Chat',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    )
                  ]),
                ),
              ))
        ],
      ),
    );
  }
}
