import 'package:flutter/material.dart';
import 'package:servicehub/view/login.dart';
import 'package:servicehub/view/on_board.dart';
import 'package:servicehub/controller/select_service_widget.dart';
import 'package:provider/provider.dart';

class MyInterestPage extends StatefulWidget {
  const MyInterestPage({super.key});

  @override
  State<MyInterestPage> createState() => _MyInterestPageState();
}

class _MyInterestPageState extends State<MyInterestPage> {
  final MyInterestStateProvider _stateProvider = MyInterestStateProvider();
  // bool atLeastOneInkwellSelected = false;

  // void updateAtLeastOneInkwellSelected() {
  //   setState(() {
  //     atLeastOneInkwellSelected = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Provider<MyInterestStateProvider>(
        create: (context) => _stateProvider,
        child: Scaffold(
            backgroundColor: Color(0xFFFDF9F9),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
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
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose the services you may have an interest for',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 15),
                            Text('Select at least one',
                                style: TextStyle(fontSize: 14)),
                            MyInterestWidget(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0, -1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        if (_stateProvider.atLeastOneInkwellSelected) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFC84457),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: Text(
                        'Continue',
                        // _stateProvider.atLeastOneInkwellSelected
                        //     ? 'Continue'
                        //     : 'Skip',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Gilroy'),
                      )),
                ),
              ),
            )));
  }
}
