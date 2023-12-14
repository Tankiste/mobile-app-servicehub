import 'package:flutter/material.dart';

class RecentOrderService extends StatefulWidget {
  const RecentOrderService({super.key});

  @override
  State<RecentOrderService> createState() => _RecentOrderServiceState();
}

class _RecentOrderServiceState extends State<RecentOrderService> {
  int selectedIndex = -1;
  List<bool> isFavoriteList = List.generate(3, (index) => false);

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, bottom: 10, left: 10),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedIndex = index;
          });
        },
        child: Container(
          height: 180,
          width: 195,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 5))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 95,
                width: 195,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  child: Image.asset(
                    'assets/salle_serveur.png',
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
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                              child: Image.asset(
                            'assets/supplier.png',
                            fit: BoxFit.cover,
                          )),
                        ),
                        const SizedBox(width: 7),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Binho',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Level 2 Supplier',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 15,
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
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
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
      height: 200,
      color: Colors.transparent,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
