import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/model/orders/manage_orders.dart';
import 'package:servicehub/view/seller/manage_order.dart';

class SellerOrdersListView extends StatefulWidget {
  SellerOrdersListView({
    super.key,
  });

  @override
  State<SellerOrdersListView> createState() => _SellerOrdersListViewState();
}

class _SellerOrdersListViewState extends State<SellerOrdersListView> {
  ManageOrders _orders = ManageOrders();
  int selectedIndex = -1;
  // int percent = 52;

  Widget serviceWidget(
      int index,
      String orderId,
      String image,
      String name,
      int price,
      int completion,
      String formattedDate,
      String orderDate,
      String clientName,
      String clientImage,
      bool terminated) {
    List<String> splitByComma = formattedDate.split(', ');
    String monthAndDay = splitByComma[1];
    List<String> splitBySpace = monthAndDay.split(' ');
    String deliverMonth = splitBySpace[0];
    String deliverDay = splitBySpace[1];

    Color textColor() {
      if (completion >= 75) {
        return Colors.green.shade700;
      } else if (completion >= 30 && completion < 75) {
        return Colors.orange.shade600;
      } else {
        return Colors.red;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 25, 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              CupertinoPageRoute(
                  builder: ((context) => ManageOrderView(
                      orderId: orderId,
                      image: image,
                      serviceName: name,
                      clientName: clientName,
                      price: price,
                      delivaryDate: formattedDate,
                      completion: completion))));
        },
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
                      child: image != null
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
                        height: 60,
                        width: 133,
                        child: Text(
                          name,
                          maxLines: 2,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'XAF ${price.toString()}',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 15),
                  Text(
                    terminated ? 'Done' : '${completion.toString()}%',
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
                  child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: clientImage != null
                          ? clientImage == ""
                              ? Image.asset(
                                  'assets/avatar.png',
                                  fit: BoxFit.cover,
                                )
                              : Image.network(clientImage, fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                      child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ));
                                }, errorBuilder: (BuildContext context,
                                      Object exception,
                                      StackTrace? stackTrace) {
                                  return Icon(Icons.error);
                                })
                          : Image.asset(
                              'assets/avatar.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 30,
                    width: 110,
                    child: Text(
                      clientName,
                      overflow: TextOverflow.clip,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('$orderDate - $deliverDay $deliverMonth',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w500,
                        )),
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot>>(
        future: _orders.getSupplierOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error while getting your orders ${snapshot.error}'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/undraw_color_palette.svg',
                  width: 200,
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'No order yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  height: 70,
                  width: 270,
                  child: Text(
                    'You will find your various orders here once a client purchases your services.',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500),
                  ),
                )
              ],
            );
          }
          if (snapshot.hasData) {
            List<DocumentSnapshot> orders = snapshot.data!;

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: orders.length,
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot order = orders[index];
                          Timestamp timestamp = order['order date'];
                          DateTime dateTime = timestamp.toDate();
                          // List<String> splitByComma = formattedDate.split(', ');
                          // String monthAndDay = splitByComma[1];
                          // List<String> splitBySpace = monthAndDay.split(' ');

                          String orderId = order.id;
                          String image = order['service poster'];
                          String name = order['service name'];
                          int price = order['price'];
                          int completion = order['completion'];
                          String formattedDate = order['deliver date'];
                          String orderDate =
                              DateFormat('dd MMM').format(dateTime);
                          String clientName = order['client name'];
                          String clientImage = order['client image'];
                          bool terminated = order['terminated'];

                          return serviceWidget(
                              index,
                              orderId,
                              image,
                              name,
                              price,
                              completion,
                              formattedDate,
                              orderDate,
                              clientName,
                              clientImage,
                              terminated);
                        }),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
// InkWell(
//       onTap: () {
//         Navigator.push(context,
//             MaterialPageRoute(builder: ((context) => ManageOrderView())));