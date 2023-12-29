import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';

class AboutView extends StatefulWidget {
  const AboutView({super.key});

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  // Widget certifications() {
  //   return ListView.builder(
  //       shrinkWrap: true,
  //       padding: EdgeInsets.zero,
  //       itemCount: 2,
  //       scrollDirection: Axis.vertical,
  //       itemBuilder: (BuildContext context, int index) {
  //         return Row(
  //           children: [
  //             Container(
  //               width: 8,
  //               height: 8,
  //               decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   border: Border.all(color: Colors.grey.shade400)),
  //             ),
  //             const SizedBox(
  //               width: 10,
  //             ),
  //             Text(
  //               'Certification No ${index + 1}',
  //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
  //             ),
  //             const SizedBox(
  //               height: 5,
  //             )
  //           ],
  //         );
  //       });
  // }

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    Timestamp timestamp = userData!.date!;
    DateTime dateTime = timestamp.toDate();
    String registerDate = DateFormat('MMM yyyy').format(dateTime);
    return userData == null
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 7, right: 20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(17, 20, 15, 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 5,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      Text(
                        userData.description ?? '',
                        textAlign: TextAlign.justify,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.locationDot,
                            size: 25,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Cameroon',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.solidUser,
                            size: 25,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Member since',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                registerDate,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.chartPie,
                            size: 25,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sector',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                userData.sector ?? 'none',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 23,
                      ),
                      Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.phone,
                            size: 25,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Phone number',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade400,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                userData.phonenumber.toString(),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(17, 17, 15, 18),
                  width: 700,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 5,
                          offset: Offset(0, 4))
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Certifications',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        userData.certification ?? 'none',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                      // certifications(),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
