import 'package:flutter/material.dart';

class SellerService extends StatefulWidget {
  const SellerService({super.key});

  @override
  State<SellerService> createState() => _SellerServiceState();
}

class _SellerServiceState extends State<SellerService> {
  int selectedIndex = -1;
  List<bool> isFavoriteList = List.generate(1, (index) => false);

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 20, bottom: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
            // Navigator.push(
            // context,
            // CupertinoPageRoute(
            //     builder: ((context) => ServiceDetailView())));
          });
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
                  child: Image.asset(
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
                        const SizedBox(width: 80),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                isFavoriteList[index] = !isFavoriteList[index];
                              });
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavoriteList[index]
                                  ? Colors.red
                                  : Colors.grey.shade300,
                            ))
                      ],
                    ),
                    Text(
                      'Lorem Ipsum dolor',
                      maxLines: 2,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        overflow: TextOverflow.clip,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
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
                            '€37.52',
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
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return serviceWidget(index);
            }),
      ),
    );
  }
}
