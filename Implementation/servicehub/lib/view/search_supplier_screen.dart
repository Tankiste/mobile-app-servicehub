import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/about_supplier.dart';
import 'package:servicehub/controller/about_view.dart';
import 'package:servicehub/controller/my_reviews.dart';
import 'package:servicehub/controller/my_services.dart';
import 'package:servicehub/controller/supplier_reviews.dart';
import 'package:servicehub/controller/supplier_service.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/view/seller/supplier_profile.dart';

class SearchSupplierScreen extends StatefulWidget {
  final DocumentSnapshot data;
  const SearchSupplierScreen({super.key, required this.data});

  @override
  State<SearchSupplierScreen> createState() => _SearchSupplierScreenState();
}

class _SearchSupplierScreenState extends State<SearchSupplierScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  String selectedOption = 'About';
  String previousOption = 'About';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateSelectedOption(String option) {
    setState(() {
      selectedOption = option;
      if (option == 'About') {
        _animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(0.0, 0.0),
        ).animate(_controller);
      } else if (option == 'Services') {
        _animation = Tween<Offset>(
          begin: previousOption == 'About'
              ? const Offset(0.0, 0.0)
              : const Offset(2.0, 0.0),
          end: const Offset(1.0, 0.0),
        ).animate(_controller);
      } else if (option == 'Reviews') {
        _animation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: const Offset(2.0, 0.0),
        ).animate(_controller);
      }
      previousOption = option;
      _controller.forward(from: 0.0);
    });
  }

  Widget buildDivider() {
    return SlideTransition(
      position: _animation,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Divider(
          height: 0,
          thickness: 2.0,
          color: const Color(0xFFC84457),
        ),
      ),
    );
  }

  Widget buildContent() {
    if (selectedOption == 'About') {
      return AboutSupplier(data: widget.data);
    } else if (selectedOption == 'Services') {
      return SupplierService(data: widget.data);
    } else if (selectedOption == 'Reviews') {
      return SupplierReviews(data: widget.data);
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    // UserData? userData = Provider.of<ApplicationState>(context).getUser;
    String? logoUrl = widget.data['logoLink'];
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.maybePop(context);
                    },
                    icon: Icon(Icons.arrow_back_ios_new_rounded)),
                Padding(
                  padding: const EdgeInsets.only(left: 140),
                  child: Column(
                    children: [
                      Container(
                        width: 95,
                        height: 95,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: logoUrl != null
                              ? CachedNetworkImage(
                                  imageUrl: logoUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                )
                              : Image.asset(
                                  "assets/avatar.png",
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.data['company name'],
                          style: GoogleFonts.roboto(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => _updateSelectedOption('About'),
                      child: Text(
                        'About',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedOption == 'About'
                              ? Color(0xFFC84457)
                              : Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _updateSelectedOption('Services'),
                      child: Text(
                        'Services',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedOption == 'Services'
                              ? Color(0xFFC84457)
                              : Colors.black,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _updateSelectedOption('Reviews'),
                      child: Text(
                        'Reviews',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: selectedOption == 'Reviews'
                              ? Color(0xFFC84457)
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                buildDivider(),
                const SizedBox(
                  height: 20,
                ),
                buildContent(),
              ],
            ),
          ))),
    );
  }
}
