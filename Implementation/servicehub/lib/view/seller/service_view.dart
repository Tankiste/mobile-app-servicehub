import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/view/home_supplier.dart';
import 'package:servicehub/controller/related_service_listview.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/services/services.dart';
// import 'package:servicehub/view/result_search_view.dart';
import 'package:like_button/like_button.dart';
import 'package:servicehub/view/seller/myservices_screen.dart';

class ServiceView extends StatefulWidget {
  final String newServiceId;
  final String? serviceType;
  const ServiceView({super.key, required this.newServiceId, this.serviceType});

  @override
  State<ServiceView> createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  // bool _isFavorite = false;
  ServiceData? serviceData;
  Services _services = Services();

  @override
  void initState() {
    fetchServiceDetails();
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  Future<void> fetchServiceDetails() async {
    ServiceData? data = await _services.getServiceById(widget.newServiceId);
    if (data != null) {
      setState(() {
        serviceData = data;
        print(serviceData);
      });
    } else
      return null;
  }

  @override
  Widget build(BuildContext context) {
    String? posterUrl = serviceData?.poster;
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    String? logoUrl = userData?.logo;

    return Scaffold(
      body: serviceData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                  padding: EdgeInsets.only(right: 5),
                                  onPressed: () {
                                    Navigator.maybePop(context);
                                  },
                                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
                            ),
                            const SizedBox(
                              width: 280,
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: IconButton(
                                  padding: EdgeInsets.only(right: 1, bottom: 3),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 280,
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
                                          child: logoUrl != null
                                              ? CachedNetworkImage(
                                                  imageUrl: logoUrl,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )
                                              : Image.asset(
                                                  "assets/avatar.png",
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
                                            userData!.username,
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
                              // LikeButton(
                              //   // onTap: (isLiked) {

                              //   // },
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              // )
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Price',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '${serviceData!.price.toString()} XAF',
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
                            RelatedServiceListView(
                              showText: false,
                              serviceId: widget.newServiceId,
                              serviceType: serviceData!.type,
                            ),
                          ]),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: ((context) =>
                            //             MyServicesScreen())));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC84457),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              )),
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 120, right: 120, top: 15, bottom: 15),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              )
            ])),
    );
  }
}
