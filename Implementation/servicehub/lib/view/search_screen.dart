import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/controller/recent_collab_search.dart';
import 'package:servicehub/controller/recent_order_search.dart';
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/view/explore_screen.dart';
import 'package:servicehub/view/result_search_view.dart';
import 'package:servicehub/view/search_supplier_screen.dart';
// import 'package:servicehub/view/home_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  FirebaseServices fbServices = FirebaseServices();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  String selectedOption = 'Services';
  String _service = "";
  bool _showInitialView = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      if (option == 'Services') {
        _animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(_controller);
      } else {
        _animation = Tween<Offset>(
          begin: const Offset(0.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(_controller);
      }
      _controller.forward(from: 0.0);
    });
  }

  Widget buildDivider() {
    return SlideTransition(
      position: _animation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Divider(
          height: 0,
          thickness: 2.0,
          color: const Color(0xFFC84457),
        ),
      ),
    );
  }

  // Widget buildContent() {
  //   if (selectedOption == 'Services') {
  //     return RecentOrderSearchView(
  //       showText: true,
  //     );
  //   } else {
  //     return RecentCollabSearchView();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // width: double.infinity,
        // height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.maybePop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  const SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: SizedBox(
                      height: 30,
                      width: 250,
                      child: TextFormField(
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                            hintText: 'Search a service...',
                            hintStyle: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade400,
                            )),
                        onChanged: (value) {
                          setState(() {
                            _service = value;
                            _showInitialView = false;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => _updateSelectedOption('Services'),
                    child: Text(
                      'Services',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: selectedOption == 'Services'
                            ? Color(0xFFC84457)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _updateSelectedOption('Suppliers'),
                    child: Text(
                      'Suppliers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: selectedOption == 'Suppliers'
                            ? Color(0xFFC84457)
                            : Colors.grey.shade500,
                      ),
                    ),
                  ),
                ],
              ),
              buildDivider(),
              // buildContent(),
              (selectedOption == 'Services')
                  ? StreamBuilder<QuerySnapshot>(
                      stream: fbServices.services.snapshots(),
                      builder: (context, snapshot) {
                        if (_service.isEmpty) {
                          return RecentOrderSearchView(
                            showText: true,
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                              'Something went wrong : ${snapshot.error}');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          );
                          // } else if (!snapshot.hasData) {
                          //   return RecentOrderSearchView(
                          //     showText: true,
                          //   );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              if (data['title']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_service)) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ResultSearchView(
                                                      serviceType: data['type']
                                                          .toString()))));
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.search_outlined,
                                                    size: 20,
                                                    color: Colors.grey.shade400,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Text(data['title']),
                                                ],
                                              ),
                                            ),
                                            Icon(
                                              Icons.call_made_outlined,
                                              size: 20,
                                              color: Colors.grey.shade400,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Divider(
                                          color: Colors.grey.shade300,
                                          indent: 10,
                                          endIndent: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          );
                        }
                      },
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: fbServices.users
                          .where('isSeller', isEqualTo: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (_service.isEmpty) {
                          return RecentCollabSearchView();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Something went wrong : ${snapshot.error}');
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            height: 50,
                            width: 50,
                            child: CircularProgressIndicator(),
                          );
                          // } else if (!snapshot.hasData) {
                          //   return RecentOrderSearchView(
                          //     showText: true,
                          //   );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var data = snapshot.data!.docs[index];
                              if (data['company name']
                                  .toString()
                                  .toLowerCase()
                                  .contains(_service)) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  SearchSupplierScreen(
                                                    data: data,
                                                  ))));
                                    },
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: Text(data['company name'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18)),
                                          leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(data['logoLink']),
                                          ),
                                        ),
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        Divider(
                                          color: Colors.grey.shade300,
                                          indent: 10,
                                          endIndent: 10,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Container();
                            },
                          );
                        }
                      },
                    )
              // RecentCollabSearchView(),
            ],
          ),
        ),
      ),
    );
  }
}
