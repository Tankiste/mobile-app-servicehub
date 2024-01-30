import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/inbox_screen.dart';
import 'package:servicehub/view/order_screen.dart';
import 'package:servicehub/view/profile_screen.dart';
import 'package:servicehub/view/seller/supplier_profile.dart';

class HomeClient extends StatefulWidget {
  const HomeClient({Key? key}) : super(key: key);

  @override
  _HomeClientState createState() => _HomeClientState();
}

class _HomeClientState extends State<HomeClient> with WidgetsBindingObserver {
  AuthService _authService = AuthService();

  // final List<Widget> _pages = [
  //   HomeScreen(),
  //   InboxScreen(),
  //   ExploreScreen(),
  //   OrderScreen(),
  //   ProfileScreen(),
  // ];

  @override
  void initState() {
    updateData();
    WidgetsBinding.instance.addObserver(this);
    setStatus('Online');
    super.initState();
  }

  void setStatus(String status) async {
    try {
      await _authService.updateStatus(status);
    } catch (err) {
      rethrow;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus('Online');
    } else {
      setStatus('Offline');
    }
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ApplicationState>(context);
    // final isSellerMode = appState.isSellerMode;
    // final isSeller = appState.isSeller;

    return Scaffold(
      // backgroundColor: Colors.white.withOpacity(0.5),
      body: Stack(
        children: [
          IndexedStack(index: appState.currentIndex, children: [
            HomeScreen(),
            InboxScreen(),
            ExploreScreen(),
            OrderScreen(),
            ProfileScreen(),
          ]),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Container(
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
                    setState(() {
                      appState.currentIndex = index;
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
                ),
              ),
            ),
          )
        ],
      ),
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      //   height: 70,
      //   decoration: BoxDecoration(
      //     color: Colors.transparent,
      //     borderRadius: BorderRadius.circular(15),
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.shade400,
      //         blurRadius: 5,
      //         offset: Offset(0, 4),
      //       ),
      //     ],
      //   ),
      //   child: ClipRRect(
      //     borderRadius: BorderRadius.circular(15),
      //     child: BottomNavigationBar(
      //       backgroundColor: Colors.white,
      //       selectedItemColor: Color(0xFFC84457),
      //       unselectedItemColor: Colors.black,
      //       currentIndex: appState.currentIndex,
      //       type: BottomNavigationBarType.fixed,
      //       elevation: 0,
      //       onTap: (int index) {
      //         setState(() {
      //           appState.currentIndex = index;
      //         });
      //       },
      //       items: <BottomNavigationBarItem>[
      //         BottomNavigationBarItem(
      //           label: 'Home',
      //           icon: Icon(Icons.home_rounded),
      //         ),
      //         BottomNavigationBarItem(
      //           label: 'Inbox',
      //           icon: Icon(FontAwesomeIcons.envelope),
      //         ),
      //         BottomNavigationBarItem(
      //           label: 'Explore',
      //           icon: Icon(Icons.manage_search),
      //         ),
      //         BottomNavigationBarItem(
      //           label: 'Orders',
      //           icon: Icon(Icons.cases_rounded),
      //         ),
      //         BottomNavigationBarItem(
      //           label: 'Account',
      //           icon: Icon(Icons.person_rounded),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
