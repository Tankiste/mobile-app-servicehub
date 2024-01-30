import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/favorite_screen.dart';
import 'package:servicehub/view/language_screen.dart';
import 'package:servicehub/view/notifications_screen.dart';
import 'package:servicehub/view/select_service.dart';
import 'package:servicehub/view/seller/earnings_screen.dart';
import 'package:servicehub/view/seller/myprofile_screen.dart';
import 'package:servicehub/view/seller/myservices_screen.dart';
import 'package:servicehub/view/update_account_screen.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';

class SupplierProfileScreen extends StatefulWidget {
  const SupplierProfileScreen({super.key});

  @override
  State<SupplierProfileScreen> createState() => _SupplierProfileScreenState();
}

class _SupplierProfileScreenState extends State<SupplierProfileScreen> {
  bool _isAuth = true;
  AuthService _authService = AuthService();
  FirebaseServices _services = FirebaseServices();
  // bool _isSellerMode = true;
  // bool isSwitched = true;

  @override
  void initState() {
    updateData();
    super.initState();
  }

  // void toggleMode(bool value) {
  //   final provider = Provider.of<ApplicationState>(context, listen: false);
  //   int newIndex = value ? 3 : 4;
  //   provider.updateIndex(value, newIndex);
  // }

  void updateSellerMode(String sellerUid, bool value) async {
    try {
      await _authService.updateSellerMode(sellerUid, value);
    } catch (err) {
      rethrow;
    }
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context, listen: true);
    final currentUser = _services.user!.uid.toString();
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    String? logoUrl = userData?.logo;
    return Scaffold(
        body: userData != null
            ? SingleChildScrollView(
                child: Container(
                  // height: double.infinity,
                  // width: double.infinity,
                  child: Padding(
                    padding: _isAuth
                        ? const EdgeInsets.only(
                            left: 30, right: 30, top: 60, bottom: 90)
                        : const EdgeInsets.only(
                            left: 30, right: 30, top: 100, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isAuth)
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
                          padding: EdgeInsets.fromLTRB(12, 12, 12, 12),
                          decoration: BoxDecoration(
                              color: appState.isSellerMode
                                  ? Colors.black
                                  : Colors.white,
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
                                  child: _isAuth
                                      ? logoUrl == ""
                                          ? Image.asset(
                                              "assets/avatar.png",
                                              fit: BoxFit.cover,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              child: logoUrl != null
                                                  ? CachedNetworkImage(
                                                      imageUrl: logoUrl,
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
                                _isAuth
                                    ? SizedBox(
                                        width: 120,
                                        child: Text(
                                          userData!.username,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: appState.isSellerMode
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text('Supplier mode',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: appState.isSellerMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            )),
                                        Transform.scale(
                                          scale: 0.7,
                                          child: Switch(
                                              activeColor: Color(0xFFC84457),
                                              activeTrackColor:
                                                  Color(0xFFFB8F9F),
                                              value: appState.isSellerMode,
                                              onChanged: (value) {
                                                final provider = Provider.of<
                                                        ApplicationState>(
                                                    context,
                                                    listen: false);
                                                // provider.toggleMode(value);
                                                // provider.refreshUser();
                                                provider.switchMode();
                                                // toggleMode(value);
                                                updateSellerMode(
                                                    currentUser, value);
                                                // appState.refreshUser();

                                                // setState(() {
                                                //   isSwitched = value;
                                                // });
                                              }),
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                        _isAuth
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
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: appState.isSellerMode
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      EarningsScreen())));
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
                                                FontAwesomeIcons.dollarSign,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              'Earnings',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 142,
                                            ),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
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
                                                      MyServicesScreen())));
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
                                                FontAwesomeIcons.layerGroup,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              'My Services',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 118,
                                            ),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
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
                                              Icons
                                                  .keyboard_arrow_right_rounded,
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
                                                      MyProfileScreen())));
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
                                                FontAwesomeIcons.solidUser,
                                                size: 30,
                                              ),
                                            ),
                                            const SizedBox(width: 20),
                                            Text(
                                              'My profile',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 133,
                                            ),
                                            Icon(
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              size: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              Icons
                                                  .keyboard_arrow_right_rounded,
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
                                                      SelectServicePage())));
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
                                              Icons
                                                  .keyboard_arrow_right_rounded,
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
                                              Icons
                                                  .keyboard_arrow_right_rounded,
                                              size: 30,
                                            )
                                          ],
                                        ),
                                      ),
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: ((context) =>
                                      //                 UpdateAccountScreen())));
                                      //   },
                                      //   child: Row(
                                      //     children: [
                                      //       Container(
                                      //         height: 45,
                                      //         width: 48,
                                      //         decoration: BoxDecoration(
                                      //             borderRadius:
                                      //                 BorderRadius.circular(11),
                                      //             color: Colors.grey.shade200),
                                      //         child: Icon(
                                      //           FontAwesomeIcons.userGear,
                                      //           size: 30,
                                      //         ),
                                      //       ),
                                      //       const SizedBox(width: 20),
                                      //       Text(
                                      //         'Account',
                                      //         style: TextStyle(
                                      //             fontSize: 16,
                                      //             fontWeight: FontWeight.w500),
                                      //       ),
                                      //       const SizedBox(
                                      //         width: 145,
                                      //       ),
                                      //       Icon(
                                      //         Icons.keyboard_arrow_right_rounded,
                                      //         size: 30,
                                      //       )
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  )),
                        _isAuth
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
                                      width: 143,
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
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                                          borderRadius:
                                              BorderRadius.circular(11),
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
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
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
                        if (_isAuth)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 150),
                            // : const EdgeInsets.only(top: 60, left: 150),
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
              )
            : Center(
                child: CircularProgressIndicator(),
              )

        // bottomNavigationBar: appState.isSwitched
        //     ? BottomBar(
        //         initialIndex: 3,
        //         isSeller: true,
        //       )
        //     : BottomBar(
        //         initialIndex: 4,
        //         isSeller: false,
        //       ));
        );
  }
}
