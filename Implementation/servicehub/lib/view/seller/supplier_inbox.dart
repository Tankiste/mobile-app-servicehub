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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SellerMessagesListView(),
      ),
    );
  }
}
