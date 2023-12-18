import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/recent_order.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/controller/service_listview.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/view/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    bool showUser = userData != null;
    String? logoUrl = userData?.logo;

    return SafeArea(
      child: Scaffold(
        // backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 15, top: 70, bottom: 100),
                  child: Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/ServiceHub.png',
                              width: 200,
                            ),
                            const SizedBox(
                              width: 100,
                            ),
                            if (showUser)
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ));
                                },
                                child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            offset: Offset(0, 4))
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: /*Image.asset(
                                    'assets/supplier.png',
                                    fit: BoxFit.cover,
                                  )*/
                                          logoUrl != null
                                              ? Image.network(logoUrl,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    value: loadingProgress
                                                                .expectedTotalBytes !=
                                                            null
                                                        ? loadingProgress
                                                                .cumulativeBytesLoaded /
                                                            loadingProgress
                                                                .expectedTotalBytes!
                                                        : null,
                                                  ));
                                                }, errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                  return Icon(Icons.error);
                                                })
                                              : Image.asset(
                                                  "/assets/avatar.png",
                                                  fit: BoxFit.cover,
                                                ),
                                    )),
                              ),
                          ],
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
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
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
                      DevListView(),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Manage your Databases',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
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
                      DatabaseListView(),
                      const SizedBox(
                        height: 40,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Edit images and videos',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
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
                      InfographyListView(),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        'Recently ordered services',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
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
            //         child: BottomBar(initialIndex: 0)),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
