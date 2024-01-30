import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/payment_screen.dart';

class OrderReview extends StatefulWidget {
  final serviceId;
  const OrderReview({super.key, required this.serviceId});

  @override
  State<OrderReview> createState() => _OrderReviewState();
}

class _OrderReviewState extends State<OrderReview> {
  String selectedOption = '';
  Services _services = Services();
  ServiceData? serviceData;

  void setSelectedOption(String option) {
    setState(() {
      selectedOption = option;
    });
  }

  @override
  void initState() {
    fetchServiceDetails();
    super.initState();
  }

  DateTime addDuration(String duration, DateTime currentDate) {
    if (duration.contains('day')) {
      int days = int.parse(duration.split(' ')[0]);
      return currentDate.add(Duration(days: days));
    } else if (duration.contains('week')) {
      int weeks = int.parse(duration.split(' ')[0]);
      return currentDate.add(Duration(days: weeks * 7));
    } else if (duration.contains('month')) {
      int months = int.parse(duration.split(' ')[0]);
      int newMonth = currentDate.month + months;
      int newYear = currentDate.year + (newMonth ~/ 12);
      newMonth = newMonth % 12;
      return DateTime(newYear, newMonth, currentDate.day, currentDate.hour,
          currentDate.minute, currentDate.second);
    }
    return currentDate;
  }

  String formatDate(DateTime date) {
    return DateFormat('E, MMM dd, y').format(date);
  }

  Future<void> fetchServiceDetails() async {
    ServiceData? data = await _services.getServiceById(widget.serviceId);
    if (data != null) {
      setState(() {
        serviceData = data;
      });
    } else
      return null;
  }

  Widget buildOption(String optionName, IconData icon) {
    bool isSelected = optionName == selectedOption;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () {
          setSelectedOption(optionName);
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
          decoration: BoxDecoration(
              color: isSelected ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: Offset(0, 4))
              ]),
          child: Row(children: <Widget>[
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 25),
            ),
            SizedBox(
              width: 20,
            ),
            Text(
              optionName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            // Expanded(
            // child:
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white,
                  border: Border.all(
                      color: isSelected ? Colors.white : Colors.black),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // )
          ]),
        ),
      ),
    );
  }

  Widget buildSheet() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30))),
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 10,
            left: 20,
            right: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 6,
                  width: 72,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Service fee',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 40,
                width: 330,
                child: Text(
                    'Helps us operate our platform and offer the best possible customer support for your orders',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500)),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    String? posterUrl = serviceData?.poster;
    int subtotal = serviceData?.price ?? 0;
    int service_fee = ((serviceData?.price ?? 0) * 0.1).toInt();
    int total_price = subtotal + service_fee;
    DateTime currentDate = DateTime.now();
    DateTime? newDate = serviceData != null
        ? addDuration(serviceData!.delivaryTime, currentDate)
        : null;
    String formattedDate = formatDate(newDate ?? DateTime.now());

    return Scaffold(
      appBar: CustomAppbar(
          text: 'Order Review',
          showFilter: false,
          returnButton: true,
          showText: false,
          actionText: ''),
      body: serviceData == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15, right: 25, top: 10, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 8, 15, 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5,
                                offset: Offset(0, 4))
                          ]),
                      child: Row(
                        children: [
                          Container(
                            height: 125,
                            width: 155,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: posterUrl != null
                                  ? CachedNetworkImage(
                                      imageUrl: posterUrl,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    )
                                  : Image.asset(
                                      'assets/concept-cloud-ai.png',
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            height: 131,
                            width: 160,
                            child: Text(serviceData!.description,
                                textAlign: TextAlign.justify,
                                maxLines: 5,
                                overflow: TextOverflow.clip,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey.shade500,
                                )),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                    Text(
                      'Choose a payment method',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        buildOption('PayPal', FontAwesomeIcons.paypal),
                        buildOption(
                            'Credit Card', FontAwesomeIcons.ccMastercard),
                        buildOption('Visa', FontAwesomeIcons.ccVisa),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text(
                          'Order summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: ((context) {
                                  return buildSheet();
                                }));
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                            ),
                            child: Icon(
                              FontAwesomeIcons.question,
                              size: 12,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10, 10, 15, 15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 5,
                                offset: Offset(0, 4))
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'Service Fee',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'XAF $subtotal',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text(
                                'XAF $service_fee',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              'Total Price',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              'XAF $total_price',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            Text(
                              'Delivery Date',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ServiceHub Inc, ServiceHub Limited',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: Colors.grey.shade400),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          if (selectedOption == 'Credit Card') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => PaymentScreen(
                                        price: total_price,
                                        serviceId: widget.serviceId,
                                        delivaryDate: formattedDate))));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFC84457),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 68, right: 68, top: 15, bottom: 15),
                          child: Text(
                            'Add payment method',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gilroy'),
                          ),
                        )),
                  ],
                ),
              ),
            ),
    );
  }
}
