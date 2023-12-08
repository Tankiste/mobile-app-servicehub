import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/messages_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class SupplierInboxScreen extends StatefulWidget {
  const SupplierInboxScreen({super.key});

  @override
  State<SupplierInboxScreen> createState() => _SupplierInboxScreenState();
}

class _SupplierInboxScreenState extends State<SupplierInboxScreen> {
  bool noMessage = false;

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
    final appBar = CustomAppbar(
        text: 'Inbox',
        showFilter: !noMessage,
        returnButton: false,
        showText: false,
        actionText: '');

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
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
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                      offset: Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BottomBar(initialIndex: 1)),
            ),
          )
        ],
      ),
    );
  }
}
