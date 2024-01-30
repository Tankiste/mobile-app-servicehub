import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/seller/become_seller.dart';
import 'package:servicehub/view/login.dart';
import 'package:servicehub/view/select_service.dart';
import 'package:servicehub/view/home_client.dart';

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Container(
                height: 640,
                width: double.infinity,
                child: Image.asset(
                  'assets/aerial-view-businessman-using-computer.png',
                  fit: BoxFit.cover,
                )),
            Positioned(
                bottom: 0,
                child: Container(
                  height: 235,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 125),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/ServiceHub.png',
                            scale: 1.2,
                          ),
                          const SizedBox(
                            height: 27,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  LoginPage())));
                                    },
                                    child: const Text(
                                      'Sign in',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF7D2231)),
                                    )),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  HomeClient())));
                                    },
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF7D2231)),
                                    ))
                              ],
                            ),
                          )
                        ]),
                  ),
                )),
            Positioned(
                bottom: 165,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginPage())));
                        },
                        child: Container(
                          height: 153,
                          width: 153,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                height: 108,
                                width: 153,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFCDCDE),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: SvgPicture.asset(
                                  'assets/undraw_search_app.svg',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Find a service',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 30),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => BecomeSellerPage())));
                        },
                        child: Container(
                          height: 153,
                          width: 153,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 10,
                                    offset: Offset(0, 5))
                              ]),
                          child: Column(
                            children: [
                              Container(
                                height: 108,
                                width: 153,
                                decoration: const BoxDecoration(
                                    color: Color(0xFFFCDCDE),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                                child: SvgPicture.asset(
                                  'assets/undraw_businessman.svg',
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Become a supplier',
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
