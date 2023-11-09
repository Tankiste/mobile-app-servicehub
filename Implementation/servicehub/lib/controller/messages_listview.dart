// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/view/chat_screen.dart';

class MessagesListView extends StatefulWidget {
  const MessagesListView({super.key});

  @override
  State<MessagesListView> createState() => _MessagesListViewState();
}

class _MessagesListViewState extends State<MessagesListView> {
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
            setState(() {
              selectedIndex = index;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChatScreen()));
            });
          },
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 5, offset: Offset(0, 4))
                  ],
                ),
                child: ClipOval(
                    child: Image.asset(
                  'assets/supplier.png',
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
                  Text(
                    'Binho',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                    width: 250,
                    child: Text(
                      'Je n’ai pas encore fini avec les interfaces requis',
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    DateFormat('HH:mm').format(DateTime.now()),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade300),
                  ),
                  Container(
                    padding: EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Color(0xFFC84457),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '2',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          height: 25,
          indent: 50,
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
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
