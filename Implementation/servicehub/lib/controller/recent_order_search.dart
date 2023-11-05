import 'package:flutter/material.dart';

class RecentOrderSearchView extends StatefulWidget {
  const RecentOrderSearchView({super.key});

  @override
  State<RecentOrderSearchView> createState() => _RecentOrderSearchViewState();
}

class _RecentOrderSearchViewState extends State<RecentOrderSearchView> {
  int selectedIndex = -1;
  List<bool> isFavoriteList = List.generate(2, (index) => false);

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: 195,
          width: 155,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey, blurRadius: 10, offset: Offset(0, 5))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 110,
                width: 155,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    'assets/floeurs.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow.shade700,
                          size: 17,
                        ),
                        Text(
                          '5.0',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.yellow.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 60,
                        ),
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
                      'Design your database',
                      textAlign: TextAlign.left,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 12,
                        overflow: TextOverflow.clip,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Row(
                        children: [
                          Text(
                            'From ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.grey.shade300,
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 15,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently ordered services',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
              TextButton(
                  onPressed: () {},
                  child: Text(
                    'Edit',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFFC84457)),
                  ))
            ],
          ),
        ),
        Container(
          height: 215,
          color: Colors.white,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (BuildContext context, int index) {
                return serviceWidget(index);
              }),
        ),
      ],
    );
  }
}
