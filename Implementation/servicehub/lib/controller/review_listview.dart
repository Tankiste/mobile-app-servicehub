import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/model/services/services.dart';

class ReviewListView extends StatefulWidget {
  final String serviceId;
  const ReviewListView({super.key, required this.serviceId});

  @override
  State<ReviewListView> createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  // int selectedIndex = -1;
  Services services = Services();

  Widget serviceWidget(int index, String name, String image, String text,
      int rating, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, left: 10, top: 15, bottom: 15),
      child: Container(
        height: 160,
        width: 255,
        padding: EdgeInsets.fromLTRB(10, 10, 20, 15),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 10, offset: Offset(0, 4))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: image == ""
                        ? Image.asset(
                            "assets/avatar.png",
                            fit: BoxFit.cover,
                          )
                        : image != null
                            ? CachedNetworkImage(
                                imageUrl: image,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            : Image.asset(
                                "assets/avatar.png",
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                SizedBox(
                  // width: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        5,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 3),
                              child: SizedBox(
                                width: 15,
                                child: Icon(
                                  index < rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.yellow.shade700,
                                  size: 18,
                                ),
                              ),
                            )),
                  ),
                  // Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: List.generate(5, (index) {
                  //     if (index < 3) {
                  //       return Icon(Icons.star_rounded,
                  //           size: 18, color: Colors.yellow.shade700);
                  //     } else if (index == 3) {
                  //       return Icon(Icons.star_half_rounded,
                  //           size: 18, color: Colors.yellow.shade700);
                  //     } else {
                  //       return Icon(Icons.star_outline_rounded,
                  //           size: 18, color: Colors.yellow.shade700);
                  //     }
                  //   }),
                  // ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              text,
              maxLines: 4,
              textAlign: TextAlign.justify,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade400),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      // color: Colors.white,
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getReviewsByServices(widget.serviceId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error in retrieving reviews: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No review yet'),
              );
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> reviews = snapshot.data!;
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: reviews.length > 3 ? 3 : reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot review = reviews[index];
                    String name = review['user name'];
                    String image = review['user logo'];
                    String text = review['review text'];
                    int rating = review['rating'];
                    Timestamp timestamp = review['date'];
                    DateTime dateTime = timestamp.toDate();
                    String formattedDate =
                        DateFormat('dd MMM, yyyy').format(dateTime);

                    return serviceWidget(
                        index, name, image, text, rating, formattedDate);
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
