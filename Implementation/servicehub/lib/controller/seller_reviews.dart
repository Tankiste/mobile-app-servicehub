import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/model/services/services.dart';

class SellerReviews extends StatefulWidget {
  const SellerReviews({super.key});

  @override
  State<SellerReviews> createState() => _SellerReviewsState();
}

class _SellerReviewsState extends State<SellerReviews> {
  Services services = Services();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;

  int? totalReviews;

  @override
  void initState() {
    getSellerReviews();
    super.initState();
  }

  Future<void> getSellerReviews() async {
    auth.User currentUser = _auth.currentUser!;
    int total = await services.getReviewsBySellers(currentUser.uid);
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
                  'You got ${totalReviews ?? 'loading...'} reviews',
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
