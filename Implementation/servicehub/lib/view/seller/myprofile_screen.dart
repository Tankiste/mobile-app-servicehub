import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicehub/controller/about_view.dart';
import 'package:servicehub/controller/supplier_reviews.dart';
import 'package:servicehub/controller/supplier_service.dart';
import 'package:servicehub/view/seller/supplier_profile.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
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
      return AboutView();
    } else if (selectedOption == 'Services') {
      return SellerService();
    } else if (selectedOption == 'Reviews') {
      return SellerReviews();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(top: 50, left: 10, bottom: 20),
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SupplierProfileScreen()));
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
                              child: Image.asset(
                            'assets/supplier.png',
                            fit: BoxFit.cover,
                          )),
                        ),
                        const SizedBox(height: 10),
                        Text('Binho Ltd',
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
            ),
          ))),
    );
  }
}
