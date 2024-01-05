import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/orders/manage_orders.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});
  static const String id = 'order-screen';

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  late Stream<QuerySnapshot> _requestStream;
  AuthService _authService = AuthService();
  ManageOrders _orders = ManageOrders();
  // late ApplicationState _appstate;

  @override
  void initState() {
    super.initState();
    _requestStream =
        FirebaseFirestore.instance.collection('orders').snapshots();
    // _appstate = Provider.of<ApplicationState>(context, listen: false);
    // _appstate.refreshUser();
  }

  void updateOrderStatus(String orderId, bool value) async {
    try {
      await _orders.updateOrderStatus(orderId, value);
      // _appstate.refreshUser();
    } catch (err) {
      rethrow;
    }
  }

  Future<List<DataRow>> createDataRows(List<DocumentSnapshot> docs) async {
    final List<DataRow> rows = [];

    for (DocumentSnapshot document in docs) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      final orderId = data['order id'] as String;
      final deliverDate = data['deliver date'] as String;
      final completion = data['completion'] as int;
      final switchValue = data['terminated'] as bool;
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
                          future: _orders.getOrders(orderId),
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
                              final orderData = snapshot.data!;
                              Timestamp timestamp = orderData['order date'];
                              DateTime dateTime = timestamp.toDate();
                              String orderDate = DateFormat('E, MMM dd, yyyy')
                                  .format(dateTime);
                              return AlertDialog(
                                title: Center(
                                    child: Text(
                                  'Order Details',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                content: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Client ID: ${orderData['client id']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Client Name: ${orderData['client name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Order Completion: ${orderData['completion'].toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text('Order Date: $orderDate',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Delivary Date: ${orderData['deliver date']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Price: ${orderData['price'].toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Supplier ID: ${orderData['seller id']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Supplier Name: ${orderData['seller name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Service ID: ${orderData['service id']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Service Name: ${orderData['service name']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20)),
                                      const SizedBox(height: 10),
                                      Text(
                                          'Completed: ${orderData['terminated'].toString()}',
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
                              return Text('Order data not found.');
                            }
                          },
                        );
                      });
                },
                child: Text(orderId))),
            DataCell(Text(deliverDate)),
            DataCell(Text(completion.toString())),
            DataCell(
              Transform.scale(
                scale: 0.9,
                child: Switch(
                  value: switchValue,
                  activeColor: Color(0xFFC84457),
                  activeTrackColor: Color(0xFFFB8F9F),
                  onChanged: (bool value) {
                    updateOrderStatus(orderId, value);
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
    // _appstate = Provider.of<ApplicationState>(context, listen: true);
    return Column(
      children: [
        const Text(
          'Orders',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _requestStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: const CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
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
                          'Order ID',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Deliver Date',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Percentage Completion',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Order Completed',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
