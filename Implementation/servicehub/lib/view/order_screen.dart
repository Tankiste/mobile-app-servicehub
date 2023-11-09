import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/orders_listview.dart';
import 'package:servicehub/controller/widgets.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool noOrder = false;

  @override
  Widget build(BuildContext context) {
    final appBar = CustomAppbar(
      text: 'Orders',
      showFilter: !noOrder,
      returnButton: false,
    );

    return Scaffold(
      appBar: appBar,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: noOrder
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/undraw_color_palette.svg',
                    width: 200,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(
                    'No order yet',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 70,
                    width: 270,
                    child: Text(
                      'You will find your various orders here. Start purchasing services for your projects.',
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey.shade500),
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrdersListView(
                    showSupplier: true,
                  ),
                ],
              ),
      ),
      bottomNavigationBar: BottomBar(initialIndex: 3),
    );
  }
}
