import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/client_orders_listview.dart';
import 'package:servicehub/controller/seller_orders_listview.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class SupplierOrderScreen extends StatefulWidget {
  const SupplierOrderScreen({super.key});

  @override
  State<SupplierOrderScreen> createState() => _SupplierOrderScreenState();
}

class _SupplierOrderScreenState extends State<SupplierOrderScreen> {
  bool noOrder = false;

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
        text: 'Orders',
        showFilter: !noOrder,
        returnButton: false,
        showText: false,
        actionText: '');

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SellerOrdersListView(),
      ),
    );
  }
}
