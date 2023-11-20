import 'package:flutter/material.dart';
import 'package:servicehub/controller/supplier_service.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/view/seller/service_screen.dart';

class MyServicesScreen extends StatefulWidget {
  const MyServicesScreen({super.key});

  @override
  State<MyServicesScreen> createState() => _MyServicesScreenState();
}

class _MyServicesScreenState extends State<MyServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          text: 'Services',
          actionText: 'Edit',
          showFilter: false,
          returnButton: true,
          showText: true),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10, 15, 0, 100),
            child: Column(
              children: [
                Expanded(
                  child: SellerService(),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => AddServiceScreen())));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC84457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 100, right: 100, top: 15, bottom: 15),
                      child: Text(
                        'Add a service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
