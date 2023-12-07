import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/view/result_search_view.dart';
import 'package:like_button/like_button.dart';

class NewServiceView extends StatefulWidget {
  const NewServiceView({super.key});

  @override
  State<NewServiceView> createState() => _NewServiceViewState();
}

class _NewServiceViewState extends State<NewServiceView> {
  // bool _isFavorite = false;

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
                                      Navigator.maybePop(context);
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '€57.63',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                ],
              ),
            )
          ])),
        ],
      ),
    );
  }
}
