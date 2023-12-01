import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';
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
  final AuthService _authService = AuthService();

  @override
  void initState() {
    updateData();
    super.initState();
  }

  signoutUser() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.logoutUser(context);
    await _authService.logout();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  updateData() async {
    ApplicationState appState = Provider.of(context, listen: false);
    await appState.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<ApplicationState>(context).getUser;
    bool showUser = userData != null;
    String? logoUrl = userData?.logo;
    final appBar = CustomAppbar(
        text: 'Account',
        showFilter: false,
        returnButton: true,
        showText: false,
        actionText: '');

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
                                    child: logoUrl != null
                                        ? Image.network(logoUrl,
                                            fit: BoxFit.cover, loadingBuilder:
                                                (BuildContext context,
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
                                                    StackTrace? stackTrace) {
                                            return Icon(Icons.error);
                                          })
                                        : Image.asset(
                                            "assets/avatar.png",
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
                                      onTap: () {},
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
                              Text(
                                'Email',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade400,
                                ),
                              ),
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
                                keyboardType: TextInputType.name,
                              ),
                            ),
                            const SizedBox(
                              height: 32,
                            ),
                            Container(
                              // color: Colors.blue,
                              padding: EdgeInsets.zero,
                              margin: EdgeInsets.zero,
                              alignment: Alignment.topCenter,
                              width: 220,
                              child: TextField(
                                keyboardType: TextInputType.name,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 230,
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
            child: Container(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.zero,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade400,
                      blurRadius: 5,
                      offset: Offset(0, 4))
                ],
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BottomBar(initialIndex: 4, isSeller: false)),
            ),
          )
        ],
      ),
      // resizeToAvoidBottomInset: true,
    );
  }
}
