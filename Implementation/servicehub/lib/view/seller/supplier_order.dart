import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/controller/orders_listview.dart';
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
      body: Stack(
        children: [
          Container(
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
                        isSupplier: true,
                      ),
                    ],
                  ),
          ),
          // Positioned(
          //   bottom: 10,
          //   left: 15,
          //   right: 15,
          //   child: Container(
          //     padding: EdgeInsets.zero,
          //     margin: EdgeInsets.zero,
          //     height: 70,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey.shade400,
          //             blurRadius: 5,
          //             offset: Offset(0, 4))
          //       ],
          //     ),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(15),
          //         child: BottomBar(initialIndex: 2)),
          //   ),
          // )
        ],
      ),
    );
  }
}
