import 'package:flutter/material.dart';
import 'package:servicehub/controller/client_orders_listview.dart';
import 'package:servicehub/controller/seller_orders_listview.dart';
import 'package:servicehub/controller/widgets.dart';

class SellerOrderView extends StatefulWidget {
  const SellerOrderView({super.key});

  @override
  State<SellerOrderView> createState() => _SellerOrderViewState();
}

class _SellerOrderViewState extends State<SellerOrderView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          text: 'Orders with Binho',
          showFilter: false,
          returnButton: true,
          showText: false,
          actionText: ''),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SellerOrdersListView(),
      ),
    );
  }
}
