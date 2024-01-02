import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/login.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/app_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<FormState> _forgotPassFormKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    updateData();
    super.initState();
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    void changePassword() async {
      if (_forgotPassFormKey.currentState!.validate()) {
        setState(() {
          isLoading = true;
        });
        String resp = await AuthService().resetPassword(_emailController.text);

        if (resp == 'success') {
          await Fluttertoast.showToast(
            msg: "The reset link was send successfully !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Color(0xFFC84457),
            // textColor: Colors.white,
            fontSize: 16.0,
          );
          // Navigator.of(context).pushAndRemoveUntil(
          //     MaterialPageRoute(builder: (context) => const LoginPage()),
          //     (Route<dynamic> route) => false);
          Navigator.pop(context);
        }
        setState(() {
          isLoading = false;
        });
      }
    }

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
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.maybePop(context);
                          },
                          icon: Icon(Icons.arrow_back_ios_new_rounded)),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'Forgot Password',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: Form(
                        key: _forgotPassFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                    hintText: 'Email or username',
                                    contentPadding: EdgeInsets.only(left: 10),
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 15),
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    if (!value.contains('@') ||
                                        !value.contains('.')) {
                                      return 'Please enter a valid email address';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            Text(
                              'Your confirmation link will be send to your email address.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade400,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: ElevatedButton(
                                  onPressed: () {
                                    isLoading ? null : changePassword();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFC84457),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 120,
                                        right: 120,
                                        top: 15,
                                        bottom: 15),
                                    child: isLoading
                                        ? CircularProgressIndicator(
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white))
                                        : Text(
                                            'Send',
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
                          ],
                        )),
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
