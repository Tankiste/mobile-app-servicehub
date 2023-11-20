import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:servicehub/view/order_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool _isLoading = false;

  void _payNow() {
    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      showDialog(
          context: context, builder: ((context) => const CustomDialogWidget()));

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
          text: 'Payment',
          showFilter: false,
          returnButton: true,
          showText: false,
          actionText: ''),
      body: Padding(
        padding: EdgeInsets.fromLTRB(25, 25, 35, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a payment method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  )),
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Card number',
                    contentPadding: EdgeInsets.only(left: 15),
                    hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  )),
              child: TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: 'First Name',
                    contentPadding: EdgeInsets.only(left: 15),
                    hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  )),
              child: TextField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                    hintText: 'Last Name',
                    contentPadding: EdgeInsets.only(left: 15),
                    hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  )),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: 'MM / YYYY',
                    contentPadding: EdgeInsets.only(left: 15),
                    hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    border: InputBorder.none),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1.5,
                    color: Colors.grey.shade300,
                  )),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: 'CVV',
                    contentPadding: EdgeInsets.only(left: 15),
                    hintStyle: TextStyle(
                        color: Colors.grey.shade300,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                    border: InputBorder.none),
              ),
            ),
            Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                  onPressed: () {
                    _isLoading ? null : _payNow();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC84457),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 68, right: 68, top: 15, bottom: 15),
                    child: _isLoading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Pay Now (€62.14)',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Gilroy'),
                          ),
                  )),
            ))
          ],
        ),
      ),
    );
  }
}

class CustomDialogWidget extends StatelessWidget {
  const CustomDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.fromLTRB(25, 45, 25, 45),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Icon(FontAwesomeIcons.creditCard,
                size: 35, color: Colors.white),
          ),
          const SizedBox(height: 32),
          Text(
            'Successful!',
            style: GoogleFonts.roboto(
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox(
            height: 45,
            width: 240,
            child: Text(
              'Your payment has been done successfully.',
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500),
            ),
          ),
          const SizedBox(
            height: 35,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: ((context) => OrderScreen())));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC84457),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    )),
                child: const Padding(
                  padding:
                      EdgeInsets.only(left: 55, right: 55, top: 5, bottom: 5),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Gilroy'),
                  ),
                )),
          )
        ]),
      ),
    );
  }
}
