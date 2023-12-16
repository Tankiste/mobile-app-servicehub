import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirebaseServices {
  User? user = FirebaseAuth.instance.currentUser;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference requests =
      FirebaseFirestore.instance.collection('Requests');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference services =
      FirebaseFirestore.instance.collection('services');
}













// Future<void> saveCategory(
  //     {CollectionReference? reference,
  //     Map<String, dynamic>? data,
  //     String? docName}) {
  //   return reference!.doc(docName).set(data);
  // }

  // Future<void> addUserData({Map<String, dynamic>? data}) {
  //   return users
  //       .doc(user!.uid)
  //       .set(data)
  //       .then((value) => print('User Added'))
  //       .catchError((error) => print('Failed to add user : $error'));
  // }