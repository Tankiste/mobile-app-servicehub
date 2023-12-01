import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:servicehub/side_bar_screens/orders.dart';
import 'package:servicehub/side_bar_screens/requests.dart';
import 'package:servicehub/side_bar_screens/transactions.dart';
import 'dashboard.dart';

class MainScreen extends StatefulWidget {
  static const String id = "main-screen";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = DashBoardScreen();

  currentScreen(item) {
    switch (item.route) {
      case DashBoardScreen.id:
        setState(() {
          _selectedScreen = DashBoardScreen();
        });
        break;
      case Requests.id:
        setState(() {
          _selectedScreen = Requests();
        });
        break;
      case Orders.id:
        setState(() {
          _selectedScreen = Orders();
        });
        break;
      case Transactions.id:
        setState(() {
          _selectedScreen = Transactions();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: const Center(
            child: Text(
          'Admin Pannel',
          style: TextStyle(color: Colors.white),
        )),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: 'Dashboard',
            route: DashBoardScreen.id,
            icon: Icons.dashboard,
          ),
          AdminMenuItem(
            title: 'Requests',
            route: Requests.id,
            icon: Icons.mark_as_unread_sharp,
          ),
          AdminMenuItem(
            title: 'Orders',
            route: Orders.id,
            icon: Icons.book,
          ),
          AdminMenuItem(
            title: 'Transactions',
            route: Transactions.id,
            icon: Icons.swap_vert_circle_rounded,
          ),
        ],
        selectedRoute: MainScreen.id,
        onSelected: (item) {
          currentScreen(item);
          // if (item.route != null) {
          //   Navigator.of(context).pushNamed(item.route!);
          // }
        },
        // header: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child: const Center(
        //     child: Text(
        //       'header',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        // footer: Container(
        //   height: 50,
        //   width: double.infinity,
        //   color: const Color(0xff444444),
        //   child: const Center(
        //     child: Text(
        //       'footer',
        //       style: TextStyle(
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
      ),
      body: SingleChildScrollView(child: _selectedScreen),
    );
  }
}
