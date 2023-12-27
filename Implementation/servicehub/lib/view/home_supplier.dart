import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/inbox_screen.dart';
import 'package:servicehub/view/order_screen.dart';
import 'package:servicehub/view/seller/supplier_dashboard.dart';
import 'package:servicehub/view/seller/supplier_inbox.dart';
import 'package:servicehub/view/seller/supplier_order.dart';
import 'package:servicehub/view/seller/supplier_profile.dart';

class HomeSupplier extends StatefulWidget {
  const HomeSupplier({Key? key}) : super(key: key);

  @override
  _HomeSupplierState createState() => _HomeSupplierState();
}

class _HomeSupplierState extends State<HomeSupplier> {
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
    // final _appState = Provider.of<ApplicationState>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<ApplicationState>(builder: (context, appState, _) {
        return Stack(
          children: [
            IndexedStack(
              index: appState.currentIndex,
              children: appState.isSellerMode
                  ? [
                      SupplierDashboard(),
                      SupplierInboxScreen(),
                      SupplierOrderScreen(),
                      SupplierProfileScreen(),
                    ]
                  : [
                      HomeScreen(),
                      InboxScreen(),
                      ExploreScreen(),
                      OrderScreen(),
                      SupplierProfileScreen(),
                    ],
            ),
            Positioned(
              bottom: 10,
              left: 15,
              right: 15,
              child: Container(
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
        );
      }),
      // bottomNavigationBar: Container(
      //   margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      //   height: 70,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
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
      //       backgroundColor: Colors.transparent,
      //       selectedItemColor: Color(0xFF289BED),
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
