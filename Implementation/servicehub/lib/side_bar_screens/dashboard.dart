import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/orders/manage_orders.dart';

class DashBoardScreen extends StatelessWidget {
  static const String id = 'dashboard-screen';
  FirebaseServices _services = FirebaseServices();
  AuthService _authService = AuthService();
  ManageOrders _manageOrders = ManageOrders();

  @override
  Widget analyticWidget({required String title, required String value}) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        height: 100,
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(value), Icon(Icons.show_chart_rounded)],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DashBoard',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _services.users.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: 'Total Users',
                      value: snapshot.data!.size.toString());
                }
                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _authService.getTotalClientsStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: 'Total Clients',
                      value: snapshot.data!.size.toString());
                }
                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _authService.getTotalSuppliersStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: 'Total Suppliers',
                      value: snapshot.data!.size.toString());
                }
                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _services.orders.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: 'Total Orders',
                      value: snapshot.data!.size.toString());
                }
                return const SizedBox();
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: _manageOrders.getCompletedOrdersStream(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blue,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )),
                  );
                }
                if (snapshot.hasData) {
                  return analyticWidget(
                      title: 'Finished Orders',
                      value: snapshot.data!.size.toString());
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ],
    );
  }
}
