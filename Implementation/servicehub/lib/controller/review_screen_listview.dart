import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewScreenListView extends StatefulWidget {
  const ReviewScreenListView({super.key});

  @override
  State<ReviewScreenListView> createState() => _ReviewScreenListViewState();
}

class _ReviewScreenListViewState extends State<ReviewScreenListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 30, bottom: 25),
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
                    child: Image.asset(
                      'assets/femme_noire.png',
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
                              'Leonce',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              DateFormat('d MMM, yyyy').format(DateTime.now()),
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
                          children: List.generate(5, (index) {
                            if (index < 3) {
                              return Icon(Icons.star_rounded,
                                  size: 20, color: Colors.yellow.shade700);
                            } else if (index == 3) {
                              return Icon(Icons.star_half_rounded,
                                  size: 20, color: Colors.yellow.shade700);
                            } else {
                              return Icon(Icons.star_outline_rounded,
                                  size: 20, color: Colors.yellow.shade700);
                            }
                          }),
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
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sed dolor non turpis euismod convallis.',
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
    return Container(
      color: Colors.white,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
