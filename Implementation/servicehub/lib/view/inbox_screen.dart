import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/messages_listview.dart';
import 'package:servicehub/controller/widgets.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool noMessage = false;

  @override
  Widget build(BuildContext context) {
    final appBar = CustomAppbar(
      text: 'Inbox',
      showFilter: !noMessage,
      returnButton: false,
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: noMessage
            ? Column(
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
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MessagesListView(),
                ],
              ),
      ),
      bottomNavigationBar: BottomBar(initialIndex: 1),
    );
  }
}
