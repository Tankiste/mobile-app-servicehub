import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String uid;
  String username;
  String email;
  String? password;
  String? confirmpassword;
  bool isSeller = false;

  UserData(
      {required this.uid,
      required this.username,
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

  static UserData fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserData(
        uid: snapshot['uid'],
        username: snapshot['username'],
        email: snapshot['email']);
  }
}
