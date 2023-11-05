import 'package:flutter/material.dart';
import 'package:servicehub/view/client_signup.dart';
import 'package:servicehub/view/forgot_password.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/select_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 15, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectServicePage()));
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded)),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 55),
                    child: Image.asset(
                      'assets/ServiceHub.png',
                      scale: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 15),
                    child: Column(
                      children: [
                        Form(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome!',
                              style: TextStyle(
                                fontFamily: 'Gilroy',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                                'Please login or sign up to continue in the app.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade400,
                                )),
                            const SizedBox(height: 35),
                            const Text('Email',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    )),
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      hintText: 'Email or username',
                                      contentPadding: EdgeInsets.only(left: 10),
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text('Password',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Gilroy',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    )),
                                child: TextFormField(
                                  obscureText: _obscurePassword,
                                  keyboardType: TextInputType.visiblePassword,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.only(left: 10, top: 10),
                                      hintText: 'Password',
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                      suffixIcon: IconButton(
                                          icon: Icon(_obscurePassword
                                              ? Icons.visibility_off
                                              : Icons.visibility),
                                          onPressed:
                                              _togglePasswordVisibility)),
                                ),
                              ),
                            ),
                            const SizedBox(height: 35),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC84457),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                        left: 120,
                                        right: 120,
                                        top: 15,
                                        bottom: 15),
                                    child: Text(
                                      'Login',
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
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 215),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordPage()));
                                },
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFC84457),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 165),
                              child: Text(
                                'or',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            color: Colors.grey.shade300))),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 40, top: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.google,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Gilroy'),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 15,
                            ),
                            ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        side: BorderSide(
                                            color: Colors.grey.shade300))),
                                child: const Padding(
                                  padding: EdgeInsets.only(
                                      left: 60, top: 15, bottom: 15),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.mail_outlined,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'Sign up with Mail',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Gilroy'),
                                      ),
                                    ],
                                  ),
                                )),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  const ClientSignUp())));
                                    },
                                    child: const Text(
                                      'Sign Up',
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
                                                  HomeScreen())));
                                    },
                                    child: const Text(
                                      'Skip',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Color(0xFF7D2231)),
                                    ))
                              ],
                            )
                          ],
                        )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
