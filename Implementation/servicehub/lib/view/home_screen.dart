import 'package:flutter/material.dart';
import 'package:servicehub/controller/recent_order.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/controller/service_listview.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, top: 70, bottom: 10),
            child: Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Image.asset(
                    'assets/ServiceHub.png',
                    width: 200,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SearchBarItem(),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Create new digital products',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFC84457),
                          ),
                        ))
                  ],
                ),
                ServiceListView(),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Edit images and videos',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFFC84457),
                          ),
                        ))
                  ],
                ),
                ServiceListView(),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'Recently ordered services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 7,
                ),
                RecentOrderService(),
              ],
            )),
          ),
        ),
      ),
      bottomNavigationBar: BottomBar(initialIndex: 0),
    );
  }
}
