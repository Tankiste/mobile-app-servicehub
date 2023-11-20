import 'package:flutter/material.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/login.dart';

class ClientSignUp extends StatefulWidget {
  const ClientSignUp({super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _confirmpassController = TextEditingController();
  bool _isChecked = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  bool _isButtonPressed = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmpassController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void registerUser() async {
      if (_formKey.currentState!.validate()) {
        String resp = await AuthService().registerUser(
            email: _emailController.text,
            username: _usernameController.text,
            password: _passwordController.text,
            confirmpassword: _confirmpassController.text);

        if (resp == 'success') {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false);
        }
      }
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
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
                          key: _formKey,
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
                                    controller: _usernameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your Username',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      return null;
                                    },
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
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your mail',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!value.contains('@')) {
                                        return 'Please enter a valid email address';
                                      }
                                      return null;
                                    },
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
                                    controller: _passwordController,
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
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
                                    controller: _confirmpassController,
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
                                            onPressed:
                                                _togglePasswordVisibility2)),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm your password';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Passwords do not match';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    side:
                                        BorderSide(color: Colors.grey.shade400),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                              if (_isButtonPressed && !_isChecked)
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    'Please agree to the terms and conditions',
                                    style: TextStyle(
                                      color: Colors.red.shade900,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 13),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isButtonPressed = true;
                                      });
                                      registerUser();
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFC84457),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        )),
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 110,
                                          right: 110,
                                          top: 15,
                                          bottom: 15),
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
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF7D2231)),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
