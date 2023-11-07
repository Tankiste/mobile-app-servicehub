import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/controller/widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 100, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(12, 12, 25, 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          blurRadius: 10,
                          offset: Offset(0, 4))
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade300),
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Client',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Welcome to ServiceHub!',
                            style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 13, 10, 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.userPlus,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Register on ServiceHub',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 35,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.arrowRightToBracket,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Login',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 165,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.language,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Language',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 135,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(12, 13, 10, 13),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade300)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.userGear,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Become a supplier',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.lock,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Privacy Policy',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 102,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Container(
                            height: 45,
                            width: 48,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(11),
                                color: Colors.grey.shade200),
                            child: Icon(
                              FontAwesomeIcons.users,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Support',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            width: 147,
                          ),
                          Icon(
                            Icons.keyboard_arrow_right_rounded,
                            size: 30,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(initialIndex: 4),
    );
  }
}
