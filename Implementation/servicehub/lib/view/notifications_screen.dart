import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicehub/controller/notifications_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
    ApplicationState _appState = Provider.of(context, listen: true);
    return Scaffold(
      appBar: CustomAppbar(
          text: 'Account notifications',
          showFilter: false,
          returnButton: true,
          showText: false,
          actionText: ''),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.fromLTRB(35, 5, 35, 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade200,
                        ),
                        child: Text(
                          'LAST 30 DAYS',
                          style: GoogleFonts.montserrat(
                              color: Colors.grey,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )),
                    NotificationsListView(),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: FloatingBar(),
          )
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
          //         child:
          //             BottomBar(initialIndex: _appState.isSellerMode ? 3 : 4)),
          //   ),
          // )
        ],
      ),
    );
  }
}
