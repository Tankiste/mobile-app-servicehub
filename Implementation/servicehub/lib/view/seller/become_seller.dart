import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/on_board.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/view/seller/seller_signup.dart';

class BecomeSellerPage extends StatefulWidget {
  const BecomeSellerPage({super.key});

  @override
  State<BecomeSellerPage> createState() => _BecomeSellerPageState();
}

class _BecomeSellerPageState extends State<BecomeSellerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFDF9F9),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new_rounded)),
              Padding(
                padding: const EdgeInsets.only(left: 170),
                child: Image.asset('assets/logo.png', width: 50),
              ),
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  'Become A Supplier',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              Padding(
                padding: EdgeInsets.only(left: 25),
                child: Column(
                  children: [
                    Text(
                      'Bring on your skills and services &',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Let us make your earnings easier.',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/undraw_world.svg',
                          width: 90,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Increased',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          'Visibility',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/undraw_select_option_re.svg',
                          width: 90,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'More',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          'Options',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/undraw_fast_loading_re.svg',
                          width: 65,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Faster',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          'Exchange',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade400,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.boxArchive),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Create A Service',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Offer your services worldwide and make',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'some profits.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.handshakeSimple),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Deliver Your Work',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Communicate with your different customers',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'and deliver their orders.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.moneyBill1),
                    const SizedBox(
                      width: 17,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Get Paid',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Get paid on time, with the freedom of',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        ),
                        Text(
                          'cash withdrawal whenever you want.',
                          style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => SellerSignUp())));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC84457),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 110, right: 110, top: 15, bottom: 15),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Gilroy'),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
