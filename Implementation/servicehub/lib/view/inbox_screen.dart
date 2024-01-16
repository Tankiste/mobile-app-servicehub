import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/messages_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/view/login.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
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

    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        if (appState.getUser != null) {
          return buildChatPage(appBar: appBar, noMessage: noMessage);
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class buildChatPage extends StatelessWidget {
  const buildChatPage({
    super.key,
    required this.appBar,
    required this.noMessage,
  });

  final CustomAppbar appBar;
  final bool noMessage;

  @override
  Widget build(BuildContext context) {
    // UserData? userData = Provider.of<ApplicationState>(context).getUser;
    // bool? isSeller = userData?.isSeller;
    return Scaffold(
      appBar: appBar,
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: ClientMessagesListView()),
    );
  }
}
