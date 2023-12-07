import 'package:flutter/material.dart';
import 'package:servicehub/controller/review_screen_listview.dart';
import 'package:servicehub/view/service_detail_view.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 18),
                  child: Text(
                    'Clients Reviews',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                ReviewScreenListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
