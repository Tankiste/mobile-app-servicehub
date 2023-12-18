// import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

class UserData {
  String uid;
  String? name;
  String username;
  String? logo;
  String? description;
  String? sector;
  String? address;
  String? website;
  String? certification;
  int? phonenumber;
  String? email;
  String? password;
  String? confirmpassword;
  bool isSeller = false;
  bool sellerMode = false;

  UserData(
      {required this.uid,
      this.name,
      required this.username,
      this.logo,
      this.description,
      this.sector,
      this.address,
      this.website,
      this.certification,
      this.phonenumber,
      required this.email,
      this.password,
      this.confirmpassword});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'isSeller': isSeller,
    };
  }

  Map<String, dynamic> toMapSupplier() {
    return {
      'uid': uid,
      'CEO name': name,
      'company name': username,
      'description': description,
      'sector': sector,
      'address': address,
      'website': website,
      'certification': certification,
      'phonenumber': phonenumber,
      'email': email,
      'logoLink': logo,
      'isSeller': isSeller,
      'sellerMode': sellerMode,
    };
  }

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    String username = snapshot['username'] ?? snapshot['company name'];
    return UserData(
      uid: snapshot['uid'],
      username: username,
      email: snapshot['email'],
      logo: snapshot['logoLink'],
    );
  }

  // static UserData fromSellerSnap(DocumentSnapshot snap) {
  //   var snapshot = snap.data() as Map<String, dynamic>;

  //   String username = snapshot['username'] ?? snapshot['company name'];
  //   return UserData(
  //     uid: snapshot['uid'],
  //     name: snapshot['CEO name'],
  //     username: username,
  //     email: snapshot['email'],
  //     logo: snapshot['logoLink'],
  //     description: snapshot['description'],
  //   );
  // }
}
