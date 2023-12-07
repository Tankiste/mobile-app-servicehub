import 'package:flutter/material.dart';
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/view/home_screen.dart';
import 'package:servicehub/view/seller/supplier_dashboard.dart';

Widget buildUserInterfaces() {
  AuthService _authService = AuthService();
  // FirebaseServices services = FirebaseServices();
  // final currentUser = services.user;

  // if (_authService.getCurrentUserStatus() == true) {
  //   return SupplierDashboard();
  // } else {
  //   return HomeScreen();
  // }

  return FutureBuilder<bool>(
    future: _authService.getCurrentUserStatus(),
    builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: Container(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        if (snapshot.data == true) {
          return SupplierDashboard();
        } else {
          return HomeScreen();
        }
      }
    },
  );
}
