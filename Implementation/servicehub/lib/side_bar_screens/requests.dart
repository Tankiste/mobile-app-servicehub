import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});
  static const String id = 'request-screen';

  @override
  State<Requests> createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  late Stream<QuerySnapshot> _requestStream;

  @override
  void initState() {
    super.initState();
    _requestStream =
        FirebaseFirestore.instance.collection('Requests').snapshots();
  }

  @override
  Widget build(BuildContext context) {
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

            return DataTable(
              columns: [
                DataColumn(
                    label: Text('Supplier UID',
                        style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Company Name',
                        style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold))),
                DataColumn(
                    label: Text('Request State',
                        style: TextStyle(
                            color: Colors.deepPurple.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold)))
              ],
              rows: snapshot.data!.docs.map<DataRow>(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;

                  return DataRow(cells: [
                    DataCell(Text(data['sellerUid'] ?? 'N/A')),
                    DataCell(Text(data['companyName'] ?? 'N/A')),
                    DataCell(Switch(value: false, onChanged: (bool value) {}))
                  ]);
                },
              ).toList(),
            );
          },
        )
      ],
    );
  }
}
