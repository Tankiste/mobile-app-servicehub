import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:servicehub/view/inbox_screen.dart';
import 'package:servicehub/view/seller_order_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messagecontroller = TextEditingController();

  List<Message> messages = [
    Message(
      text: 'Tu as pu résoudre l’énigme?',
      date: DateTime.now().subtract(Duration(days: 5, minutes: 1)),
      isSentByMe: true,
    ),
    Message(
      text: 'Non, mais je suis sur la bonne voix.',
      date: DateTime.now().subtract(Duration(days: 5, minutes: 2)),
      isSentByMe: false,
    ),
    Message(
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit consectetur adipiscing elit.',
      date: DateTime.now().subtract(Duration(days: 4, minutes: 3)),
      isSentByMe: true,
    ),
    Message(
      text: 'Lorem ipsum deni',
      date: DateTime.now().subtract(Duration(days: 4, minutes: 4)),
      isSentByMe: false,
    ),
    Message(
      text: 'Lorem ipsum...',
      date: DateTime.now().subtract(Duration(days: 4, minutes: 5)),
      isSentByMe: true,
    ),
    Message(
      text: 'Lorem ipsum...',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 6)),
      isSentByMe: false,
    ),
    Message(
      text: 'Lorem ipsum...',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 7)),
      isSentByMe: true,
    ),
    Message(
      text: 'Lorem ipsum...',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 8)),
      isSentByMe: false,
    ),
    Message(
      text: 'Lorem ipsum...',
      date: DateTime.now().subtract(Duration(days: 3, minutes: 9)),
      isSentByMe: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Row(children: [
                IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                const SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(0, 4))
                      ]),
                  child: Row(
                    children: [
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                            child: Image.asset(
                          'assets/supplier.png',
                          fit: BoxFit.cover,
                        )),
                      ),
                      const SizedBox(width: 17),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Binho',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              )),
                          Text('Online',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFC84457),
                                fontWeight: FontWeight.w300,
                              ))
                        ],
                      ),
                      const SizedBox(width: 100),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => SellerOrderView())));
                          },
                          icon: Icon(FontAwesomeIcons.fileCircleQuestion,
                              size: 30, color: Colors.black))
                    ],
                  ),
                )
              ]),
            ),
            Expanded(
                child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (message) => DateTime(
                message.date.year,
                message.date.month,
                message.date.day,
              ),
              groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                      child: Card(
                          color: Colors.white,
                          child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                DateFormat.yMMMd().format(message.date),
                                style: TextStyle(color: Colors.grey.shade400),
                              ))))),
              itemBuilder: (context, Message message) => Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: message.isSentByMe
                      ? EdgeInsets.fromLTRB(100, 5, 20, 5)
                      : EdgeInsets.fromLTRB(20, 5, 100, 5),
                  child: Card(
                      color: message.isSentByMe
                          ? Color(0xFFFDD7D7)
                          : Color(0xFFF2F2F2),
                      shadowColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: message.isSentByMe
                              ? BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.zero)
                              : BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.zero,
                                  bottomRight: Radius.circular(15))),
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          message.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        ),
                      )),
                ),
              ),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    // color: Colors.grey.shade300,
                    height: 55,
                    width: 260,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(30)),
                    child: TextField(
                      minLines: 1,
                      maxLines: 10,
                      textAlign: TextAlign.left,
                      controller: _messagecontroller,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(FontAwesomeIcons.paperclip,
                              color: Colors.grey.shade400, size: 28),
                          onPressed: () {},
                        ),
                        prefixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                FontAwesomeIcons.camera,
                                size: 26,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: double.infinity,
                              color: Colors.grey.shade300,
                              margin:
                                  EdgeInsets.only(right: 8, top: 5, bottom: 5),
                            ),
                          ],
                        ),
                        contentPadding: EdgeInsets.all(12),
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade500,
                        ),
                        border: InputBorder.none,
                      ),
                    )),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        final message = Message(
                            text: _messagecontroller.text,
                            date: DateTime.now(),
                            isSentByMe: true);

                        // setState(() => messages.add(message) );
                        setState(() {
                          messages.add(message);
                          _messagecontroller.clear();
                        });
                      },
                      icon: Icon(
                        FontAwesomeIcons.solidPaperPlane,
                        color: Colors.white,
                        size: 30,
                      )),
                )
              ],
            ),
            const SizedBox(height: 15)
          ],
        ),
      ),
    );
  }
}
