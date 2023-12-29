import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/model/services/services.dart';

class SupplierReviews extends StatefulWidget {
  final DocumentSnapshot data;
  const SupplierReviews({super.key, required this.data});

  @override
  State<SupplierReviews> createState() => _SupplierReviewsState();
}

class _SupplierReviewsState extends State<SupplierReviews> {
  Services services = Services();
  int? totalReviews;

  @override
  void initState() {
    getSellerReviews();
    super.initState();
  }

  Future<void> getSellerReviews() async {
    int total = await services.getReviewsBySellers(widget.data.id);
    setState(() {
      totalReviews = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 20),
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 10, 15, 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 5,
                offset: Offset(1, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total reviews',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.solidEye,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  'Has ${totalReviews ?? 'loading...'} reviews',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
