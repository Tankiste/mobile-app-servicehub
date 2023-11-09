import 'package:flutter/material.dart';

class OrdersListView extends StatefulWidget {
  bool showSupplier = false;

  OrdersListView({super.key, required this.showSupplier});

  @override
  State<OrdersListView> createState() => _OrdersListViewState();
}

class _OrdersListViewState extends State<OrdersListView> {
  int selectedIndex = -1;
  int percent = 52;

  Color textColor() {
    if (percent >= 75) {
      return Colors.green;
    } else if (percent >= 30 && percent < 75) {
      return Colors.orange.shade600;
    } else {
      return Colors.red;
    }
  }

  Widget serviceWidget(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 25, 10),
      child: Container(
        height: 172,
        width: 419,
        padding: EdgeInsets.fromLTRB(10, 10, 3, 5),
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
                  height: 95,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/concept-cloud-ai.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 55,
                      width: 133,
                      child: Text(
                        'Lorem ipsum',
                        maxLines: 2,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '€56.64',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 30),
                Text(
                  '${percent.toString()}%',
                  style: TextStyle(
                      color: textColor(),
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
                //
              ],
            ),
            const SizedBox(height: 10),
            Container(
                child: widget.showSupplier
                    ? Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: ClipOval(
                                child: Image.asset(
                              'assets/supplier.png',
                              fit: BoxFit.cover,
                            )),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Binho',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 90),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Text('12 Oct - 19 Oct',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.grey.shade300,
                                  fontWeight: FontWeight.w500,
                                )),
                          )
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 20, left: 190),
                        child: Text('12 Oct - 19 Oct',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey.shade300,
                              fontWeight: FontWeight.w500,
                            )),
                      )),
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
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return serviceWidget(index);
          }),
    );
  }
}
