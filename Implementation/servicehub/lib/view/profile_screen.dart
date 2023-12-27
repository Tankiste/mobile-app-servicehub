import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
// import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/view/client_signup.dart';
import 'package:servicehub/view/favorite_screen.dart';
import 'package:servicehub/view/language_screen.dart';
import 'package:servicehub/view/login.dart';
import 'package:servicehub/view/my_interests.dart';
import 'package:servicehub/view/notifications_screen.dart';
import 'package:servicehub/view/select_service.dart';
import 'package:servicehub/view/seller/seller_signup.dart';
import 'package:servicehub/view/update_account_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
    ApplicationState appState = Provider.of(context, listen: false);
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    bool isClient = userData != null;
    String? logoUrl = userData?.logo;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: Padding(
              padding: isClient
                  ? const EdgeInsets.only(
                      left: 30,
                      right: 30,
                      top: 60,
                    )
                  : const EdgeInsets.only(
                      left: 30, right: 30, top: 100, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isClient)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          NotificationScreen())));
                            },
                            child: Container(
                              // alignment: Alignment.center,
                              padding: EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(FontAwesomeIcons.solidBell,
                                  size: 28, color: Colors.black),
                            ),
                          )),
                    ),
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
                            child: isClient
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: logoUrl != null
                                        ? Image.network(logoUrl,
                                            fit: BoxFit.cover, loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                            if (loadingProgress == null)
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
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                            return Icon(Icons.error);
                                          })
                                        : Image.asset(
                                            "assets/avatar.png",
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          isClient
                              ? Text(
                                  userData.username,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Client',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
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
                  isClient
                      ? const SizedBox(
                          height: 50,
                        )
                      : const SizedBox(
                          height: 70,
                        ),
                  Container(
                    padding: EdgeInsets.fromLTRB(12, 13, 10, 13),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: isClient
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              FavoriteScreen())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          color: Colors.grey.shade200),
                                      child: Icon(
                                        FontAwesomeIcons.solidHeart,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Saved lists',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 127,
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              MyInterestPage())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          color: Colors.grey.shade200),
                                      child: Icon(
                                        FontAwesomeIcons.solidBookmark,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Interests',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 142,
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LanguageScreen())));
                                  print(appState.currentIndex);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                              const SizedBox(
                                height: 20,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              UpdateAccountScreen())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
                                          color: Colors.grey.shade200),
                                      child: Icon(
                                        FontAwesomeIcons.userGear,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Account',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(
                                      width: 145,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right_rounded,
                                      size: 30,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              ClientSignUp())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) => LoginPage())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: ((context) =>
                                              LanguageScreen())));
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 45,
                                      width: 48,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                  isClient
                      ? const SizedBox(
                          height: 30,
                        )
                      : const SizedBox(
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => SellerSignUp())));
                          },
                          child: Row(
                            children: [
                              Container(
                                height: 45,
                                width: 48,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(11),
                                    color: Colors.grey.shade200),
                                child: isClient
                                    ? Icon(
                                        FontAwesomeIcons.solidUser,
                                        size: 30,
                                      )
                                    : Icon(
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
                  ),
                  if (isClient)
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 150),
                      child: Text(
                        '1.0.0',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                ],
              ),
            ),
          ),
          // Positioned(
          //   bottom: 10,
          //   left: 15,
          //   right: 15,
          //   child: Container(
          //     padding: EdgeInsets.zero,
          //     margin: EdgeInsets.zero,
          //     height: 70,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey.shade400,
          //             blurRadius: 5,
          //             offset: Offset(0, 4))
          //       ],
          //     ),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(15),
          //         child: BottomBar(initialIndex: 4)),
          //   ),
          // )
        ],
      ),
    );
  }
}
