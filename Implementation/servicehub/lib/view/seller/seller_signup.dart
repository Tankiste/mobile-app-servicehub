import 'package:flutter/material.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/login.dart';
import 'package:servicehub/view/request_send.dart';
// import 'package:servicehub/view/seller/become_seller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class SellerSignUp extends StatefulWidget {
  const SellerSignUp({super.key});

  @override
  State<SellerSignUp> createState() => _SellerSignUpState();
}

class _SellerSignUpState extends State<SellerSignUp> {
  TextEditingController _companynameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _sectorController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmpassController = TextEditingController();
  bool _isChecked = false;
  bool _obscurePassword = true;
  bool _obscurePassword2 = true;
  bool _isButtonPressed = false;
  File? image;
  GlobalKey<FormState> _registerSupplierKey = GlobalKey<FormState>();

  String? fileName;

  Future<bool> requestGalleryPermission() async {
    final status = await Permission.storage.status;
    debugPrint("storage permission $status");
    if (status.isDenied) {
      debugPrint("storage permission === $status");
      final granted = await Permission.storage.request();
      return granted.isGranted;
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      return true;
    }
  }

  Future pickImage() async {
    final hasPermission = await requestGalleryPermission();
    if (!hasPermission) {
      return null;
    }
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      setState(() {
        image = File(result.files.single.path!);
        fileName = result.files.first.name;
      });
    } else {
      print('No Image Selected');
    }
  }

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
    void registerSupplier() async {
      if (_registerSupplierKey.currentState!.validate()) {
        if (image != null) {
          String resp = await AuthService().registerSeller(
              name: _nameController.text,
              email: _emailController.text,
              username: _companynameController.text,
              logo: image!,
              description: _descriptionController.text,
              sector: _sectorController.text,
              address: _addressController.text,
              phonenumber: int.parse(_phoneNumberController.text),
              password: _passwordController.text,
              confirmpassword: _confirmpassController.text);

          if (resp == 'success') {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const RequestSend()),
                (Route<dynamic> route) => false);
          }
          print(resp);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: Colors.white,
                icon: Image.asset(
                  'assets/alert.png',
                  width: 30,
                ),
                title: Text('Image Required'),
                content: Text('Please select an image!'),
                actions: [
                  TextButton(
                    child: Text('OK',
                        style: TextStyle(
                            color: Color(0xFFC84457),
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
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
                      Navigator.maybePop(context);
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
                          key: _registerSupplierKey,
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
                              const Text('CEO Full Name',
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
                                    controller: _nameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your name',
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              // const SizedBox(height: 10),
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 5),
                              //   child: Container(
                              //     decoration: BoxDecoration(
                              //         shape: BoxShape.rectangle,
                              //         borderRadius: BorderRadius.circular(6),
                              //         border: Border.all(
                              //           color: Colors.grey.shade300,
                              //         )),
                              //     child: TextFormField(
                              //       keyboardType: TextInputType.name,
                              //       decoration: InputDecoration(
                              //           hintText: 'Lastname',
                              //           contentPadding: EdgeInsets.only(left: 10),
                              //           hintStyle: TextStyle(
                              //               color: Colors.grey.shade400,
                              //               fontWeight: FontWeight.w300,
                              //               fontSize: 15),
                              //           border: InputBorder.none),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 25),
                              const Text("Company's Name",
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
                                    controller: _companynameController,
                                    keyboardType: TextInputType.name,
                                    decoration: InputDecoration(
                                        hintText: "Enter your Company's Name",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your Company's Name";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              const Text("Company's Logo",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Gilroy',
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 110),
                                child: Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      shape: BoxShape.circle),
                                  child: ClipOval(
                                    child: InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: image == null
                                          ? Icon(
                                              Icons.add_a_photo,
                                              color: Colors.black,
                                              size: 40,
                                            )
                                          : Stack(
                                              children: [
                                                Image.file(
                                                  image!,
                                                  width: 140,
                                                  height: 140,
                                                  fit: BoxFit.cover,
                                                ),
                                                Positioned(
                                                    bottom: 50,
                                                    right: 50,
                                                    child: Icon(
                                                        Icons
                                                            .camera_alt_rounded,
                                                        color: Colors
                                                            .grey.shade400,
                                                        size: 40))
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Description",
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
                                  height: 100,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      )),
                                  child: TextFormField(
                                    controller: _descriptionController,
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Description on the enterprise as a whole",
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 5, bottom: 5),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your username';
                                      }
                                      if (value.length < 150) {
                                        return 'Please enter atleast 150 words';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 215),
                                child: Text(
                                  'At least 150 caracters',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Sector",
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
                                    controller: _sectorController,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Main activity carried out by the enterprise",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your company's sector";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Physical Address",
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
                                    controller: _addressController,
                                    keyboardType: TextInputType.streetAddress,
                                    decoration: InputDecoration(
                                        hintText:
                                            "Enter the enterprise’s location",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your physical address';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Website (optional)",
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
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                        hintText: "Enter enterprise’s website",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Company's Certifications (optional)",
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
                                    keyboardType: TextInputType.url,
                                    decoration: InputDecoration(
                                        hintText: "Enter enterprise’s website",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        hintStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              const Text("Phone Number",
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
                                    controller: _phoneNumberController,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                        prefixText: "(+237)",
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        prefixStyle: TextStyle(
                                            color: Colors.grey.shade400,
                                            fontWeight: FontWeight.w300,
                                            fontSize: 15),
                                        border: InputBorder.none),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a phone number';
                                      }
                                      if (value.length != 9) {
                                        return 'Phone number should have exactly 9 digits';
                                      }
                                      // if (!value.startsWith('6')) {
                                      //   return 'Phone number should start with 6';
                                      // }
                                      return null; // Return null if the input is valid
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
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
                              const SizedBox(
                                height: 25,
                              ),
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
                              const SizedBox(height: 25),
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
                              const SizedBox(height: 30),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _isButtonPressed = true;
                                      });
                                      registerSupplier();
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
