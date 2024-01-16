// import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/chatRoom/chatRoom.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/chat_screen.dart';

class ClientMessagesListView extends StatefulWidget {
  const ClientMessagesListView({super.key});

  @override
  State<ClientMessagesListView> createState() => _ClientMessagesListViewState();
}

class _ClientMessagesListViewState extends State<ClientMessagesListView> {
  Chats _chats = Chats();
  Services _services = Services();

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

  Widget serviceWidget(int index, UserData supplierData,
      DocumentSnapshot document, Message latestMessage) {
    String? logoUrl = supplierData.logo;
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiverData: supplierData,
                          )));
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
                  child: logoUrl != null
                      ? logoUrl == ""
                          ? Image.asset(
                              "assets/avatar.png",
                              fit: BoxFit.cover,
                            )
                          : Image.network(logoUrl, fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ));
                            }, errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                              return Icon(Icons.error);
                            })
                      : Image.asset(
                          "assets/avatar.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    supplierData.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                    width: 250,
                    child: Text(
                      latestMessage.text,
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
                    DateFormat('HH:mm').format(latestMessage.date),
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
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _chats.getClientChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/undraw_writer_re.svg',
                  width: 200,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'No message yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 70,
                  width: 270,
                  child: Text(
                    'You will find your various exchanges with suppliers here. Send your first message.',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade500,
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> documents = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 20, top: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = documents[index];
                          String supplierId = document['seller id'];
                          String chatId = document['chat id'];
                          return FutureBuilder<UserData?>(
                              future: _services.getSupplier(supplierId),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (userSnapshot.hasData) {
                                  UserData supplierData = userSnapshot.data!;
                                  return FutureBuilder<List<Message>>(
                                      future: _chats.getLatestMessage(chatId),
                                      builder: (context, messageSnapshot) {
                                        if (messageSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else if (messageSnapshot.hasData) {
                                          Message latestMessage =
                                              messageSnapshot.data![0];
                                          return serviceWidget(
                                              index,
                                              supplierData,
                                              document,
                                              latestMessage);
                                        } else {
                                          return Container();
                                        }
                                      });
                                } else {
                                  return Container();
                                }
                              });
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}

class SellerMessagesListView extends StatefulWidget {
  const SellerMessagesListView({super.key});

  @override
  State<SellerMessagesListView> createState() => _SellerMessagesListViewState();
}

class _SellerMessagesListViewState extends State<SellerMessagesListView> {
  Chats _chats = Chats();
  AuthService _authService = AuthService();

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

  Widget serviceWidget(int index, UserData clientData,
      DocumentSnapshot document, Message latestMessage) {
    String? logoUrl = clientData.logo;
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            receiverData: clientData,
                          )));
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
                  child: logoUrl != null
                      ? logoUrl == ""
                          ? Image.asset(
                              "assets/avatar.png",
                              fit: BoxFit.cover,
                            )
                          : Image.network(logoUrl, fit: BoxFit.cover,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                  child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ));
                            }, errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                              return Icon(Icons.error);
                            })
                      : Image.asset(
                          "assets/avatar.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    clientData.username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 20,
                    width: 250,
                    child: Text(
                      latestMessage.text,
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
                    DateFormat('HH:mm').format(latestMessage.date),
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
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _chats.getSellerChats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/undraw_writer_re.svg',
                  width: 200,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'No message yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 70,
                  width: 270,
                  child: Text(
                    'You will find your various exchanges with clients here. Send your first message.',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey.shade500,
                    ),
                  ),
                )
              ],
            );
          } else if (snapshot.hasData) {
            List<DocumentSnapshot> documents = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(bottom: 100, left: 20, top: 15),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot document = documents[index];
                          String clientId = document['client id'];
                          String chatId = document['chat id'];
                          return FutureBuilder<UserData?>(
                              future: _authService.getClient(clientId),
                              builder: (context, userSnapshot) {
                                if (userSnapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (userSnapshot.hasData) {
                                  UserData clientData = userSnapshot.data!;
                                  return FutureBuilder<List<Message>>(
                                      future: _chats.getLatestMessage(chatId),
                                      builder: (context, messageSnapshot) {
                                        if (messageSnapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        } else if (messageSnapshot.hasData) {
                                          Message latestMessage =
                                              messageSnapshot.data![0];
                                          return serviceWidget(
                                              index,
                                              clientData,
                                              document,
                                              latestMessage);
                                        } else {
                                          return Container();
                                        }
                                      });
                                } else {
                                  return Container();
                                }
                              });
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
