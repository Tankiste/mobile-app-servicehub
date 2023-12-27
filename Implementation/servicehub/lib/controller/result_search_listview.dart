import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/service_detail_view.dart';

class ResultSearchListView extends StatefulWidget {
  final String serviceType;
  const ResultSearchListView({super.key, required this.serviceType});

  @override
  State<ResultSearchListView> createState() => _ResultSearchListViewState();
}

class _ResultSearchListViewState extends State<ResultSearchListView> {
  // int selectedIndex = -1;
  // bool isFavorite = false;
  Services services = Services();
  late List<bool> isFavoriteList;

  @override
  void initState() {
    // isFavoriteList = List.filled(0, false);
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<DocumentSnapshot> documents =
        await services.getResultServices(widget.serviceType);
    setState(() {
      isFavoriteList = List.generate(documents.length, (index) => false);
    });
  }

  // void likeService(int index) {
  //   setState(() {
  //     isFavoriteList[index] = !isFavoriteList[index];
  //   });
  // }

  // void likeService() {
  //   isFavorite = !isFavorite;
  // }

  Widget serviceWidget(DocumentSnapshot document, int index) {
    String? posterUrl = document['poster'];
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 25),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) => ServiceDetailView(
                      serviceId: document.id,
                      serviceType: widget.serviceType))));
        },
        child: Container(
          height: 160,
          // width: 300,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 160,
                width: 175,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15)),
                  child: posterUrl != null
                      ? Image.network(posterUrl, fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                              child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ));
                        }, errorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                          return Icon(Icons.error);
                        })
                      : Image.asset(
                          'assets/digital_marketing.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 20,
                        ),
                        Text(
                          '5.0',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 90),
                        // IconButton(
                        //     onPressed: () {
                        //       likeService();
                        //     },
                        //     icon: Icon(
                        //       Icons.favorite,
                        //       color: isFavorite
                        //           ? Colors.red
                        //           : Colors.grey.shade300,
                        //     )),
                        GestureDetector(
                            onTap: () {
                              // likeService(index);
                              setState(() {
                                isFavoriteList[index] = !isFavoriteList[index];
                              });
                            },
                            child: Icon(
                              Icons.favorite,
                              color: isFavoriteList[index]
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ))
                      ],
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(
                        document['title'],
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        children: [
                          Text(
                            'From ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade400,
                            ),
                          ),
                          Text(
                            'XAF ${document['price']}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // color: Colors.white,
      child: FutureBuilder<List<DocumentSnapshot>>(
          future: services.getResultServices(widget.serviceType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error while loading data : ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data found'));
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> documents = snapshot.data!;
              // isFavoriteList = List.filled(documents.length, false);

              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: documents.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = documents[index];
                    return serviceWidget(document, index);
                  });
            } else
              return Container();
          }),
    );
  }
}
