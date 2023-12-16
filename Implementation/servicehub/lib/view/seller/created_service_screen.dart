import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:servicehub/view/seller/new_service_view.dart';

class CreatedServiceScreen extends StatefulWidget {
  final String newServiceId; // Ajoutez cette variable

  const CreatedServiceScreen({Key? key, required this.newServiceId})
      : super(key: key);

  @override
  State<CreatedServiceScreen> createState() => _CreatedServiceScreenState();
}

class _CreatedServiceScreenState extends State<CreatedServiceScreen> {
  bool isPlaying = false;
  final controller = ConfettiController();

  @override
  void initState() {
    super.initState();

    controller.play();
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'SERVICE CREATED',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 170),
                SvgPicture.asset(
                  'assets/undraw_done.svg',
                  width: 220,
                ),
                const SizedBox(height: 35),
                Text(
                  'SERVICE SUCCESSFULLY',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text('CREATED',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    )),
                SizedBox(
                  height: 70,
                  width: 240,
                  child: Text(
                    "You are done. Your service is now available on the market place for buyers to purchase.",
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey.shade500),
                  ),
                ),
                // Text(
                //   'has been reviewed.',
                //   style: TextStyle(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w300,
                //     color: Colors.grey.shade500,
                //   ),
                // ),
                const SizedBox(
                  height: 120,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: ((context) => NewServiceView(
                                      newServiceId: widget.newServiceId,
                                    ))));
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
                          ),
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
      ),
      ConfettiWidget(
        confettiController: controller,
        blastDirectionality: BlastDirectionality.explosive,
        gravity: 0.2,
      )
    ]);
  }
}
