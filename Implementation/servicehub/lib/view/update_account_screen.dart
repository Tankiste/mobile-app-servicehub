import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/view/home_client.dart';
import 'package:servicehub/view/home_supplier.dart';
// import 'package:servicehub/view/client_signup.dart';
// import 'package:servicehub/view/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool isLoading = false;
  File? image;
  String? fileName;

  @override
  void initState() {
    updateData();
    super.initState();
  }

  signoutUser() async {
    ApplicationState appState = Provider.of(context, listen: false);
    appState.currentIndex = 0;
    await appState.logoutUser(context);
    await _authService.logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

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

  @override
  Widget build(BuildContext context) {
    // ApplicationState _appState = Provider.of(context, listen: true);
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    // bool showUser = userData != null;
    String? logoUrl = userData?.logo;
    bool isSeller = userData!.isSeller!;
    final appBar = CustomAppbar(
        text: 'Account',
        showFilter: false,
        returnButton: true,
        showText: false,
        actionText: '');

    void updateAccount() async {
      setState(() {
        isLoading = true;
      });
      String resp = await AuthService().updateAccount(
        username: _nameController.text,
        logo: image,
      );

      if (resp == 'success') {
        await Fluttertoast.showToast(
          msg: "Your informations have been updated successfully !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFFC84457),
          // textColor: Colors.white,
          fontSize: 16.0,
        );

        if (isSeller) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeSupplier()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeClient()),
              (Route<dynamic> route) => false);
        }
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //     content:
        //         Text('Your informations have been updated successfully !')));
      }
      setState(() {
        isLoading = false;
      });
      print(resp);
    }

    return Scaffold(
      appBar: appBar,
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 55, left: 40, right: 40),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                  height: 105,
                                  width: 120,
                                  margin: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: image == null
                                        ? logoUrl != null
                                            ? logoUrl == ""
                                                ? Image.asset(
                                                    "assets/avatar.png",
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.network(logoUrl,
                                                    fit: BoxFit.cover,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ));
                                                  }, errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                    return Icon(Icons.error);
                                                  })
                                            : Image.asset(
                                                "assets/avatar.png",
                                                fit: BoxFit.cover,
                                              )
                                        : Image.file(
                                            image!,
                                            width: 105,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                  )),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(7),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.grey.shade400,
                                              blurRadius: 10,
                                              offset: Offset(1, 3))
                                        ]),
                                    child: InkWell(
                                      onTap: () {
                                        pickImage();
                                      },
                                      child: Icon(
                                        FontAwesomeIcons.pen,
                                        size: 20,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Upload image',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 27),
                          child: Column(
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                              // Text(
                              //   'Email',
                              //   style: TextStyle(
                              //     fontSize: 18,
                              //     fontWeight: FontWeight.bold,
                              //     color: Colors.grey.shade400,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        Column(
                          children: [
                            Container(
                              // color: Colors.blue,
                              padding: EdgeInsets.zero,
                              alignment: Alignment.topCenter,
                              width: 220,
                              child: TextField(
                                controller: _nameController,
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            // Container(
                            //   // color: Colors.blue,
                            //   padding: EdgeInsets.zero,
                            //   margin: EdgeInsets.zero,
                            //   alignment: Alignment.topCenter,
                            //   width: 220,
                            //   child: TextField(
                            //     controller: _emailController,
                            //     keyboardType: TextInputType.name,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          isLoading ? null : updateAccount();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC84457),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 82, right: 82, top: 15, bottom: 15),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Update Info',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontFamily: 'Gilroy'),
                                ),
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                        onPressed: signoutUser,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFC84457),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )),
                        child: const Padding(
                          padding: EdgeInsets.only(
                              left: 80, right: 20, top: 15, bottom: 15),
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_outlined,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Log Out',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Gilroy'),
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 15,
            right: 15,
            child: FloatingBar(),
          )
          // Positioned(
          //   bottom: 10,
          //   left: 15,
          //   right: 15,
          //   child: Container(
          //     padding: EdgeInsets.zero,
          //     margin: EdgeInsets.zero,
          //     height: 70,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(15),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Colors.grey.shade400,
          //             blurRadius: 5,
          //             offset: Offset(0, 4))
          //       ],
          //     ),
          //     child: ClipRRect(
          //         borderRadius: BorderRadius.circular(15),
          //         child:
          //             BottomBar(initialIndex: _appState.isSellerMode ? 3 : 4)),
          //   ),
          // )
        ],
      ),
      // resizeToAvoidBottomInset: true,
    );
  }
}
