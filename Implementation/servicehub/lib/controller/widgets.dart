import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/home_client.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/home_supplier.dart';
import 'package:servicehub/view/inbox_screen.dart';
import 'package:servicehub/view/order_screen.dart';
import 'package:servicehub/view/profile_screen.dart';
import 'package:servicehub/view/search_screen.dart';
import 'package:servicehub/view/seller/supplier_dashboard.dart';
import 'package:servicehub/view/seller/supplier_inbox.dart';
import 'package:servicehub/view/seller/supplier_order.dart';
import 'package:servicehub/view/seller/supplier_profile.dart';

class SearchBarItem extends StatelessWidget {
  const SearchBarItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 30),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
              )
            ]),
        child: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
          child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        SearchScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      Animation<Offset> offsetAnimation = Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ));
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Search Categories',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade400,
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
// TextField(
//               readOnly: true,
//               style: TextStyle(fontSize: 13),
//               decoration: InputDecoration(
//                   hintText: 'Search Categories',
//                   hintStyle: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w400,
//                     color: Colors.grey.shade400,
//                   ),
//                   prefixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey.shade400,
//                   ),
//                   border: InputBorder.none),
//             ),

// ignore: must_be_immutable
class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  String text = 'Inbox';
  String actionText = 'Withdrawal';
  bool showFilter = true;
  bool returnButton = true;
  bool showText = false;
  CustomAppbar(
      {super.key,
      required this.text,
      required this.actionText,
      required this.showFilter,
      required this.returnButton,
      required this.showText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFFFDF9F9),
      automaticallyImplyLeading: returnButton ? true : false,
      elevation: 2,
      title: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      actions: [
        if (showFilter)
          IconButton(
            onPressed: () {},
            icon: Icon(
              FontAwesomeIcons.sliders,
              size: 20,
              color: Colors.black,
            ),
          ),
        if (showText)
          TextButton(
              onPressed: () {},
              child: Text(
                actionText,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFC84457),
                  fontWeight: FontWeight.w500,
                ),
              ))
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class Message {
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message(
      {required this.text, required this.date, required this.isSentByMe});
}

class BottomBar extends StatefulWidget {
  final int initialIndex;
  // final bool isSellerMode;

  const BottomBar(
      {Key? key, required this.initialIndex /*required this.isSellerMode*/})
      : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int currentPageIndex;

  @override
  void initState() {
    // final _appState = Provider.of<ApplicationState>(context);
    // final currentIndex = _appState.currentIndex;
    // currentPageIndex = currentIndex;
    currentPageIndex = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    final isSellerMode = appState.isSellerMode;
    final isSeller = appState.isSeller;

    return isSellerMode
        ? BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF289BED),
            unselectedItemColor: Colors.black,
            currentIndex: currentPageIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
                print(currentPageIndex);
                switch (currentPageIndex) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SupplierDashboard()));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SupplierInboxScreen()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SupplierOrderScreen()));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const SupplierProfileScreen()));
                    break;
                  default:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SupplierDashboard()));
                    break;
                }
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Inbox',
                icon: Icon(FontAwesomeIcons.envelope),
              ),
              BottomNavigationBarItem(
                label: 'Orders',
                icon: Icon(Icons.cases_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Account',
                icon: Icon(Icons.person_rounded),
              ),
            ],
          )
        : BottomNavigationBar(
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFFC84457),
            unselectedItemColor: Colors.black,
            currentIndex: currentPageIndex,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
            onTap: (int index) {
              setState(() {
                currentPageIndex = index;
                print(currentPageIndex);
                switch (currentPageIndex) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InboxScreen()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExploreScreen()));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const OrderScreen()));
                    break;
                  case 4:
                    if (isSeller) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SupplierProfileScreen()));
                    } else {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfileScreen()));
                    }

                    break;
                  default:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    break;
                }
              });
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: 'Home',
                icon: Icon(Icons.home_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Inbox',
                icon: Icon(FontAwesomeIcons.envelope),
              ),
              BottomNavigationBarItem(
                label: 'Explore',
                icon: Icon(Icons.manage_search),
              ),
              BottomNavigationBarItem(
                label: 'Orders',
                icon: Icon(Icons.cases_rounded),
              ),
              BottomNavigationBarItem(
                label: 'Account',
                icon: Icon(Icons.person_rounded),
              ),
            ],
          );
  }
}

// Widget floatingBar() {
//   // final appState = ApplicationState();
//   Consumer<ApplicationState>(builder: (context, appState, _) {
//     if (appState.isSeller) {
//       return Container(
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade400,
//               blurRadius: 5,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: appState.isSellerMode
//               ? BottomNavigationBar(
//                   backgroundColor: Colors.transparent,
//                   selectedItemColor: Color(0xFF289BED),
//                   unselectedItemColor: Colors.black,
//                   currentIndex: appState.currentIndex,
//                   type: BottomNavigationBarType.fixed,
//                   elevation: 0,
//                   onTap: (int index) {
//                     appState.currentIndex = index;
//                   },
//                   items: <BottomNavigationBarItem>[
//                     BottomNavigationBarItem(
//                       label: 'Home',
//                       icon: Icon(Icons.home_rounded),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Inbox',
//                       icon: Icon(FontAwesomeIcons.envelope),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Orders',
//                       icon: Icon(Icons.cases_rounded),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Account',
//                       icon: Icon(Icons.person_rounded),
//                     ),
//                   ],
//                 )
//               : BottomNavigationBar(
//                   backgroundColor: Colors.white,
//                   selectedItemColor: Color(0xFFC84457),
//                   unselectedItemColor: Colors.black,
//                   currentIndex: appState.currentIndex,
//                   type: BottomNavigationBarType.fixed,
//                   elevation: 0,
//                   onTap: (int index) {
//                     appState.currentIndex = index;
//                   },
//                   items: <BottomNavigationBarItem>[
//                     BottomNavigationBarItem(
//                       label: 'Home',
//                       icon: Icon(Icons.home_rounded),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Inbox',
//                       icon: Icon(FontAwesomeIcons.envelope),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Explore',
//                       icon: Icon(Icons.manage_search),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Orders',
//                       icon: Icon(Icons.cases_rounded),
//                     ),
//                     BottomNavigationBarItem(
//                       label: 'Account',
//                       icon: Icon(Icons.person_rounded),
//                     ),
//                   ],
//                 ),
//         ),
//       );
//     } else {
//       return Container(
//         // margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
//         height: 70,
//         decoration: BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.circular(15),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade400,
//               blurRadius: 5,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(15),
//           child: BottomNavigationBar(
//             backgroundColor: Colors.white,
//             selectedItemColor: Color(0xFFC84457),
//             unselectedItemColor: Colors.black,
//             currentIndex: appState.currentIndex,
//             type: BottomNavigationBarType.fixed,
//             elevation: 0,
//             onTap: (int index) {
//               appState.currentIndex = index;
//             },
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 label: 'Home',
//                 icon: Icon(Icons.home_rounded),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Inbox',
//                 icon: Icon(FontAwesomeIcons.envelope),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Explore',
//                 icon: Icon(Icons.manage_search),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Orders',
//                 icon: Icon(Icons.cases_rounded),
//               ),
//               BottomNavigationBarItem(
//                 label: 'Account',
//                 icon: Icon(Icons.person_rounded),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
//   });
//   return Container(height: 50, width: 300, color: Colors.white);
// }

class FloatingBar extends StatefulWidget {
  const FloatingBar({super.key});

  @override
  State<FloatingBar> createState() => _FloatingBarState();
}

class _FloatingBarState extends State<FloatingBar> {
  // late int currentPageIndex;

  // @override
  // void initState(){
  //   currentPageIndex =
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.isSeller) {
        return Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: appState.isSellerMode
                ? BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    selectedItemColor: Color(0xFF289BED),
                    unselectedItemColor: Colors.black,
                    currentIndex: appState.currentIndex,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    onTap: (int index) {
                      appState.currentIndex = index;
                      // print(appState.currentIndex);
                      switch (appState.currentIndex) {
                        case 0:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 1:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 2:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 3:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        default:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                      }
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: 'Home',
                        icon: Icon(Icons.home_rounded),
                      ),
                      BottomNavigationBarItem(
                        label: 'Inbox',
                        icon: Icon(FontAwesomeIcons.envelope),
                      ),
                      BottomNavigationBarItem(
                        label: 'Orders',
                        icon: Icon(Icons.cases_rounded),
                      ),
                      BottomNavigationBarItem(
                        label: 'Account',
                        icon: Icon(Icons.person_rounded),
                      ),
                    ],
                  )
                : BottomNavigationBar(
                    backgroundColor: Colors.white,
                    selectedItemColor: Color(0xFFC84457),
                    unselectedItemColor: Colors.black,
                    currentIndex: appState.currentIndex,
                    type: BottomNavigationBarType.fixed,
                    elevation: 0,
                    onTap: (int index) {
                      appState.currentIndex = index;
                      switch (appState.currentIndex) {
                        case 0:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 1:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 2:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 3:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        case 4:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                        default:
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeSupplier()));
                          break;
                      }
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: 'Home',
                        icon: Icon(Icons.home_rounded),
                      ),
                      BottomNavigationBarItem(
                        label: 'Inbox',
                        icon: Icon(FontAwesomeIcons.envelope),
                      ),
                      BottomNavigationBarItem(
                        label: 'Explore',
                        icon: Icon(Icons.manage_search),
                      ),
                      BottomNavigationBarItem(
                        label: 'Orders',
                        icon: Icon(Icons.cases_rounded),
                      ),
                      BottomNavigationBarItem(
                        label: 'Account',
                        icon: Icon(Icons.person_rounded),
                      ),
                    ],
                  ),
          ),
        );
      } else {
        return Container(
          // margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Color(0xFFC84457),
              unselectedItemColor: Colors.black,
              currentIndex: appState.currentIndex,
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              onTap: (int index) {
                appState.currentIndex = index;
                switch (appState.currentIndex) {
                  case 0:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                  case 4:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                  default:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeClient()));
                    break;
                }
              },
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Inbox',
                  icon: Icon(FontAwesomeIcons.envelope),
                ),
                BottomNavigationBarItem(
                  label: 'Explore',
                  icon: Icon(Icons.manage_search),
                ),
                BottomNavigationBarItem(
                  label: 'Orders',
                  icon: Icon(Icons.cases_rounded),
                ),
                BottomNavigationBarItem(
                  label: 'Account',
                  icon: Icon(Icons.person_rounded),
                ),
              ],
            ),
          ),
        );
      }
    });
  }
}
