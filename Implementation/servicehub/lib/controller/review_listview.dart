import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewListView extends StatefulWidget {
  const ReviewListView({super.key});

  @override
  State<ReviewListView> createState() => _ReviewListViewState();
}

class _ReviewListViewState extends State<ReviewListView> {
  int selectedIndex = -1;

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
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
                      child: Image.asset(
                    'assets/femme_noire.png',
                    fit: BoxFit.cover,
                  )),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Leonce',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      DateFormat('d MMM, yyyy').format(DateTime.now()),
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
                    children: List.generate(5, (index) {
                      if (index < 3) {
                        return Icon(Icons.star_rounded,
                            size: 18, color: Colors.yellow.shade700);
                      } else if (index == 3) {
                        return Icon(Icons.star_half_rounded,
                            size: 18, color: Colors.yellow.shade700);
                      } else {
                        return Icon(Icons.star_outline_rounded,
                            size: 18, color: Colors.yellow.shade700);
                      }
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean sed dolor non turpis euismod convallis.',
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
      height: 160,
      // color: Colors.white,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
