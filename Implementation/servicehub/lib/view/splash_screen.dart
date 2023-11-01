import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'on_board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  // static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (ctx) => const OnBoard()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Color(0xFFF4E4E4),
        body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image: AssetImage('assets/logo.png'), width: 100),
                SizedBox(height: 20),
                Image(image: AssetImage('assets/ServiceHub.png')),
              ],
            )));
  }
}
