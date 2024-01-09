import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/orders/manage_orders.dart';
import 'package:servicehub/model/services/services.dart';
import 'package:servicehub/view/seller/earnings_screen.dart';

class SupplierDashboard extends StatefulWidget {
  const SupplierDashboard({super.key});

  @override
  State<SupplierDashboard> createState() => _SupplierDashboardState();
}

class _SupplierDashboardState extends State<SupplierDashboard> {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  Services services = Services();
  ManageOrders manageOrders = ManageOrders();
  int? ordersTodo;
  double? withdrawal;
  int? totalReviews;
  double? averageRate;
  double? completedOrders;

  @override
  void initState() {
    getSellerReviews();
    getSupplierOrders();
    getSupplierWithdrawal();
    getSupplierAverageRate();
    getSupplierOrderCompletion();
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  Future<void> getSellerReviews() async {
    auth.User currentUser = _auth.currentUser!;
    int total = await services.getReviewsBySellers(currentUser.uid);
    setState(() {
      totalReviews = total;
    });
  }

  Future<void> getSupplierOrders() async {
    int total = await manageOrders.getSupplierOrdersCount();
    setState(() {
      ordersTodo = total;
    });
  }

  Future<void> getSupplierWithdrawal() async {
    double total = await manageOrders.getSupplierWithdrawal();
    setState(() {
      withdrawal = total;
    });
  }

  Future<void> getSupplierAverageRate() async {
    double total = await services.getSupplierAverageRate();
    setState(() {
      averageRate = total;
    });
  }

  Future<void> getSupplierOrderCompletion() async {
    double total = await manageOrders.getSupplierOrderCompletion();
    setState(() {
      completedOrders = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    String? logoUrl = userData?.logo;
    // Timestamp? timestamp = userData?.date;

    String formatTimestamp(Timestamp? timestamp) {
      if (timestamp == null) {
        return '';
      }

      DateTime currentDate = DateTime.now();
      DateTime registerDate = timestamp.toDate();

      DateTime nextEvaluationDate = registerDate.add(Duration(days: 30));

      while (nextEvaluationDate.isBefore(currentDate)) {
        nextEvaluationDate = nextEvaluationDate.add(Duration(days: 30));
      }

      String formattedDate = DateFormat('MMM dd, y').format(nextEvaluationDate);

      if (nextEvaluationDate.day == currentDate.day &&
          nextEvaluationDate.month == currentDate.month &&
          nextEvaluationDate.year == currentDate.year) {
        nextEvaluationDate = nextEvaluationDate.add(Duration(days: 30));
        formattedDate = DateFormat('MMM dd, y').format(nextEvaluationDate);
      }

      return formattedDate;
    }

    return (userData == null || averageRate == null || completedOrders == null)
        ? Center(
            child: Container(
                height: 50, width: 50, child: CircularProgressIndicator()),
          )
        : Scaffold(
            body: Stack(
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 70, 20, 90),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userData!.username,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => ProfileScreen(),
                                  // ));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 5,
                                          offset: Offset(0, 4))
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: logoUrl != null
                                        ? Image.network(logoUrl,
                                            fit: BoxFit.cover, loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent?
                                                        loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                                child:
                                                    CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ));
                                          }, errorBuilder:
                                                (BuildContext context,
                                                    Object exception,
                                                    StackTrace? stackTrace) {
                                            return Icon(Icons.error);
                                          })
                                        : Image.asset(
                                            "assets/avatar.png",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 35,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Performance',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Supplier level',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Level 2',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Next Evaluation',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      formatTimestamp(userData.date),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        CircularProgressBar(
                                          percentage: completedOrders,
                                          isRating: false,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 90,
                                          height: 50,
                                          child: Text(
                                            'Order Completion',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircularProgressBar(
                                          percentage: 100,
                                          isRating: false,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 50,
                                          child: Text(
                                            'On-time delivery',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        CircularProgressBar(
                                          percentage: averageRate,
                                          isRating: true,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 70,
                                          height: 50,
                                          child: Text(
                                            'Global rating',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 27,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 160),
                                  child: Row(
                                    children: [
                                      Text(
                                        'How to raise your level',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          // showModalBottomSheet(
                                          //     isScrollControlled: true,
                                          //     context: context,
                                          //     builder: ((context) {
                                          //       return buildSheet();
                                          //     }));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                            border:
                                                Border.all(color: Colors.white),
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.question,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 3,
                                    offset: Offset(2, 2))
                              ],
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Earnings',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EarningsScreen(),
                                            ));
                                      },
                                      child: Text(
                                        'Details',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFC84457),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  'Available for withdrawal',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  withdrawal != null
                                      ? 'XAF ${withdrawal!.toStringAsFixed(0)}'
                                      : 'loading...',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC84457),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 3,
                                    offset: Offset(2, 2))
                              ],
                            ),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    'To-dos',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${ordersTodo ?? 'loading...'} Active Orders',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Get to it.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade400,
                                    blurRadius: 3,
                                    offset: Offset(2, 2))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Services',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total No. of Reviews',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    Text(
                                      '${totalReviews ?? 'loading...'}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 10,
                //   left: 15,
                //   right: 15,
                //   child: Container(
                //     padding: EdgeInsets.zero,
                //     margin: EdgeInsets.zero,
                //     height: 70,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(15),
                //       boxShadow: [
                //         BoxShadow(
                //             color: Colors.grey.shade400,
                //             blurRadius: 5,
                //             offset: Offset(0, 4))
                //       ],
                //     ),
                //     child: ClipRRect(
                //         borderRadius: BorderRadius.circular(15),
                //         child: BottomBar(initialIndex: 0)),
                //   ),
                // )
              ],
            ),
          );
  }
}

class CircularProgressBar extends StatefulWidget {
  final percentage;
  final bool isRating;

  CircularProgressBar({required this.percentage, required this.isRating});

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late AnimationController _ratingController;
  late Animation<double> _ratingAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation = Tween<double>(begin: 0, end: widget.percentage / 100)
        .animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();

    _ratingController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    _ratingAnimation = Tween<double>(begin: 0, end: widget.percentage / 5)
        .animate(_ratingController)
      ..addListener(() {
        setState(() {});
      });
    _ratingController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // Color color = calculateColor(widget.percentage);

    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: widget.isRating
                      ? _ratingAnimation.value
                      : _animation.value,
                  strokeCap: StrokeCap.round,
                  color: widget.isRating
                      ? _getColor(_ratingAnimation.value)
                      : _getColor(_animation.value),
                ),
                Center(
                  child: Text(
                    widget.isRating
                        ? (_ratingAnimation.value == 0.0)
                            ? 'N/A'
                            : '${(_ratingAnimation.value * 5).toStringAsFixed(1)}'
                        : '${(_animation.value * 100).toStringAsFixed(0)}%',
                    style: GoogleFonts.lato(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
        ],
      ),
    );
  }

  Color _getColor(double progress) {
    if (progress == 0) {
      return Colors.grey;
    } else if (progress < 0.30) {
      return Colors.red;
    } else if (progress < 0.50) {
      return Colors.orange;
    } else if (progress < 0.75) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}
