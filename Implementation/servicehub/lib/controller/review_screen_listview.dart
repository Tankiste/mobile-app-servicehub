import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/model/services/services.dart';

class ReviewScreenListView extends StatefulWidget {
  final String serviceId;
  const ReviewScreenListView({super.key, required this.serviceId});

  @override
  State<ReviewScreenListView> createState() => _ReviewScreenListViewState();
}

class _ReviewScreenListViewState extends State<ReviewScreenListView> {
  Services services = Services();
  // int selectedIndex = -1;

  Widget serviceWidget(int index, String name, String image, String text,
      int rating, String formattedDate) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 30,
        bottom: 25,
      ),
      child: Container(
        height: 180,
        width: 388,
        padding: EdgeInsets.fromLTRB(10, 10, 20, 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                  color: Colors.grey, blurRadius: 15, offset: Offset(0, 5))
            ]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 55,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: image == ""
                        ? Image.asset(
                            "assets/avatar.png",
                            fit: BoxFit.cover,
                          )
                        : image != null
                            ? Image.network(image, fit: BoxFit.cover,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ));
                              }, errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                return Icon(Icons.error);
                              })
                            : Image.asset(
                                "assets/avatar.png",
                                fit: BoxFit.cover,
                              ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                      const SizedBox(
                        width: 60,
                      ),
                      SizedBox(
                        // width: 50,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                              5,
                              (index) => Padding(
                                    padding: const EdgeInsets.only(right: 3),
                                    child: SizedBox(
                                      width: 17,
                                      child: Icon(
                                        index < rating
                                            ? Icons.star
                                            : Icons.star_border,
                                        color: Colors.yellow.shade700,
                                        size: 20,
                                      ),
                                    ),
                                  )),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 110,
                      width: 230,
                      child: Text(
                        text,
                        maxLines: 4,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey.shade500),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(width: 70),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
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
