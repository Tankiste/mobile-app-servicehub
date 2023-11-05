import 'package:flutter/material.dart';
import 'package:servicehub/view/login.dart';

class ClientSignUp extends StatefulWidget {
  const ClientSignUp({super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  bool _isChecked = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _obscurePassword2 = !_obscurePassword2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(right: 15, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: 'Gilroy',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text('Create a new account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade400,
                            )),
                        const SizedBox(height: 40),
                        const Text('Username',
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
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  hintText: 'Enter your Username',
                                  contentPadding: EdgeInsets.only(left: 10),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
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
                                  hintText: 'Enter your mail',
                                  contentPadding: EdgeInsets.only(left: 10),
                                  hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15),
                                  border: InputBorder.none),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
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
                                      onPressed: _togglePasswordVisibility)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 13),
                        const Text('Confirm Password',
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
                                      icon: Icon(_obscurePassword2
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: _togglePasswordVisibility2)),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              side: BorderSide(color: Colors.grey.shade400),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              value: _isChecked,
                              onChanged: (value) {
                                setState(() {
                                  _isChecked = value!;
                                });
                              },
                              activeColor: Color(0xFFC84457),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'By creating an account, you are agreeing with our terms',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                ),
                                Text(
                                  '& conditions.',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 13),
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
                                    left: 110, right: 110, top: 15, bottom: 15),
                                child: Text(
                                  'Sign Up',
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
                        const SizedBox(height: 10),
                      ],
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 300),
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => LoginPage())));
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 17, color: Color(0xFF7D2231)),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
