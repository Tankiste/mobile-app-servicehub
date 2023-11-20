import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/view/chat_screen.dart';

class NotificationsListView extends StatefulWidget {
  const NotificationsListView({super.key});

  @override
  State<NotificationsListView> createState() => _NotificationsListViewState();
}

class _NotificationsListViewState extends State<NotificationsListView> {
  int selectedIndex = -1;

  // late String currentTime;

  // @override
  // void initState() {
  //   // Mise à jour de l'heure actuelle toutes les secondes
  //   Timer.periodic(Duration(seconds: 1), (timer) {
  //     print(timer.isActive);
  //     setState(() {
  //       currentTime = DateFormat('h:mm').format(DateTime.now());
  //     });
  //   });
  //   super.initState();
  // }

  Widget serviceWidget(int index) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // setState(() {
            //   selectedIndex = index;
            //   Navigator.push(context,
            //       MaterialPageRoute(builder: (context) => ChatScreen()));
            // });
          },
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 5, offset: Offset(0, 4))
                  ],
                ),
                child: ClipOval(
                    child: Image.asset(
                  'assets/logo_serviceHub.png',
                  fit: BoxFit.cover,
                )),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 40,
                    width: 270,
                    child: Text(
                      'Still don’t have a supplier account, steps to follow',
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Text(
                    '2 weeks ago',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          height: 25,
          indent: 60,
          endIndent: 15,
          color: Colors.grey.shade200,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.only(left: 15, right: 15, top: 10),
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
