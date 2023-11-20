import 'package:flutter/material.dart';
import 'package:servicehub/controller/orders_listview.dart';
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
        child: SingleChildScrollView(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row(
                  //   children: [
                  //     IconButton(
                  //         onPressed: () {
                  //           // Navigator.push(
                  //           //     context,
                  //           //     MaterialPageRoute(
                  //           //         builder: (context) => LoginPage()));
                  //         },
                  //         icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  //     const SizedBox(
                  //       width: 20,
                  //     ),
                  //     Text(
                  //       'Orders with Binho',
                  //       style: TextStyle(
                  //           fontSize: 25, fontWeight: FontWeight.bold),
                  //     )
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  // Container(
                  //   height: 3,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       color: Colors.grey.shade300,
                  //       boxShadow: [
                  //         BoxShadow(
                  //             color: Colors.grey,
                  //             blurRadius: 5,
                  //             offset: Offset(0, 4))
                  //       ]),
                  // ),
                  OrdersListView(
                    showSupplier: false,
                    isSupplier: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
