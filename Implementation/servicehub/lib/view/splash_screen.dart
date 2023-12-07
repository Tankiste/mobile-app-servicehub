import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/user_interface.dart';
import 'package:servicehub/side_bar_screens/main_screen.dart';
// import 'package:servicehub/view/home_screen.dart';
import 'on_board.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const String id = 'splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (ctx) {
            if (kIsWeb) {
              return MainScreen();
            } else {
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      return buildUserInterfaces();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('%*${snapshot.error}'),
                      );
                    }
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return OnBoard();
                },
              );
            }
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF4E4E4),
        body: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Image.asset('assets/logo.png'),
                ),
                // Image(image: AssetImage('assets/logo.png'), width: 100),
                SizedBox(height: 20),
                Container(
                  height: 80,
                  width: 800,
                  child: Image.asset('assets/ServiceHub.png'),
                ),
                // Image(image: AssetImage('assets/ServiceHub.png')),
              ],
            )));
  }
}
