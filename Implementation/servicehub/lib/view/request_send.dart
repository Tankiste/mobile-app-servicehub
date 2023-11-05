import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/home_screen.dart';

class RequestSend extends StatelessWidget {
  const RequestSend({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'REQUEST TO SELL',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 150),
              SvgPicture.asset(
                'assets/undraw_mail_sent.svg',
                width: 200,
              ),
              const SizedBox(height: 35),
              Text(
                'SUPPLIER REQUEST',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text('SUBMITTED',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  )),
              Text(
                "You’ll be notified by ServiceHub once it",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey.shade500),
              ),
              Text(
                'has been reviewed.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(
                height: 140,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => HomeScreen())));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC84457),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: 100, right: 100, top: 15, bottom: 15),
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
              const SizedBox(
                height: 7,
              )
            ],
          ),
        ),
      ),
    );
  }
}
