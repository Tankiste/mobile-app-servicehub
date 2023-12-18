import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
// import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Requests extends StatefulWidget {
  const Requests({Key? key}) : super(key: key);
  static const String id = 'request-screen';

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  late Stream<QuerySnapshot> _requestStream;
  AuthService _authService = AuthService();
  late ApplicationState _appstate;
  // Map<String, bool> _switchValues = {};

  // void updateSwitchState(bool value, String sellerUid) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setBool('isRequestSwitched_$sellerUid', value);
  // }

  @override
  void initState() {
    super.initState();
    _requestStream =
        FirebaseFirestore.instance.collection('Requests').snapshots();
    _appstate = Provider.of<ApplicationState>(context, listen: false);
    _appstate.refreshUser();
    // restoreSwitchState();
  }

  // void restoreSwitchState() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final snapshot =
  //       await FirebaseFirestore.instance.collection('Requests').get();
  //   for (DocumentSnapshot document in snapshot.docs) {
  //     Map<String, dynamic> data = document.data() as Map<String, dynamic>;
  //     final sellerUid = data['sellerUid'] as String;
  //     bool? isSwitched = prefs.getBool('isRequestSwitched_$sellerUid');
  //     if (isSwitched != null) {
  //       setState(() {
  //         _appstate.isRequestSwitched = isSwitched;
  //       });
  //     }
  //   }
  // }

  void updateSellerStatus(String sellerUid, bool value) async {
    try {
      await _authService.updateUserStatus(sellerUid, value);
      // _appstate.refreshUser();
    } catch (err) {
      rethrow;
    }
  }

  void updateSellerMode(String sellerUid, bool value) async {
    try {
      await _authService.updateSellerMode(sellerUid, value);
    } catch (err) {
      rethrow;
    }
  }

  // Future<bool> getRequestStatus(String sellerUid) async {
  //   try {
  //     await _authService.getUserStatus(sellerUid);
  //   } catch (err) {
  //     rethrow;
  //   }
  //   return false;
  // }

  void updateRequestStatus(String companyName, bool value) async {
    try {
      await _authService.updateRequestStatus(companyName, value);
      _appstate.refreshUser();
    } catch (err) {
      rethrow;
    }
  }

  Future<List<DataRow>> createDataRows(List<DocumentSnapshot> docs) async {
    final List<DataRow> rows = [];

    for (DocumentSnapshot document in docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final sellerUid = data['sellerUid'] as String;
      final companyName = data['companyName'] as String;
      final switchValue = data['isSeller'] as bool;
      // _switchValues.putIfAbsent(sellerUid, () => _appstate.isRequestSwitched);

      // restoreSwitchState();

      rows.add(
        DataRow(
          cells: [
            DataCell(TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return FutureBuilder<Map<String, dynamic>>(
                          future: _authService.getUserData(sellerUid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Text(
                                  'Error loading seller data: ${snapshot.error}');
                            } else if (snapshot.hasData) {
                              final sellerData = snapshot.data!;
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                  'User Details',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'CEO Name: ${sellerData['CEO name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text('Address: ${sellerData['address']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Certification: ${sellerData['certification'] ?? 'null'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Company Name: ${sellerData['company name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Description: ${sellerData['description']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text('Email: ${sellerData['email']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Link of Logo: ${sellerData['logoLink']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Phone Number: ${sellerData['phonenumber']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text('Sector: ${sellerData['sector']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Website: ${sellerData['website'] ?? 'null'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 20),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Center(
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ))
                                ],
                              );
                            } else {
                              return Text('Seller data not found.');
                            }
                          },
                        );
                      });
                },
                child: Text(data['sellerUid'] ?? 'N/A'))),
            DataCell(Text(data['companyName'] ?? 'N/A')),
            DataCell(
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: switchValue,
                  activeColor: Color(0xFFC84457),
                  activeTrackColor: Color(0xFFFB8F9F),
                  onChanged: (bool value) {
                    // setState(() {
                    //   _switchValues[sellerUid] = value;
                    // });
                    // updateSwitchState(value, sellerUid);
                    // _appstate.toggleRequestSwitch(value);
                    updateSellerStatus(sellerUid, value);
                    updateRequestStatus(companyName, value);
                    updateSellerMode(sellerUid, value);
                    print(switchValue.toString());
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    _appstate = Provider.of<ApplicationState>(context, listen: true);
    return Column(
      children: [
        const Text(
          'Sellers Requests',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _requestStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Text(
                'No requests yet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              );
            }

            return FutureBuilder<List<DataRow>>(
              future: createDataRows(snapshot.data!.docs),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Error creating rows');
                }

                return Consumer<ApplicationState>(
                    builder: (context, appState, _) {
                  return DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Supplier UID',
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Company Name',
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Request State',
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: snapshot.data!,
                  );
                });
              },
            );
          },
        ),
      ],
    );
  }
}
