import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:servicehub/model/auth/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  // final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  // UserData? _userExist(auth.User? user) {
  //   if (user == null) {
  //     return null;
  //   }
  //   return UserData(user.uid, user.email, user.displayName);
  // }

  // Stream<UserData?>? get user {}

  // Future<UserData?> signIn(String email, String password) async {}

  // Future<UserData?> register(String email, String password) async {}

  // Future<void> signOuit() async {}

  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> registerUser({
    required String email,
    required String username,
    required String password,
    required String confirmpassword,
  }) async {
    String resp = 'Some Error occured';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          confirmpassword.isNotEmpty) {
        auth.UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        UserData userData = UserData(
            uid: cred.user!.uid,
            username: username,
            email: email,
            password: password,
            confirmpassword: confirmpassword);

        userData.isSeller = false;

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userData.toMap());

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<String> registerSeller({
    required String name,
    required String email,
    required String username,
    required File logo,
    required String description,
    required String sector,
    required String address,
    String? website,
    String? certification,
    required int phonenumber,
    required String password,
    required String confirmpassword,
  }) async {
    String resp = 'Some Error occured';
    try {
      if (email.isNotEmpty &&
          password.isNotEmpty &&
          username.isNotEmpty &&
          confirmpassword.isNotEmpty &&
          name.isNotEmpty &&
          description.isNotEmpty &&
          sector.isNotEmpty &&
          address.isNotEmpty) {
        String imageUrl = await uploadImageToStorage('Logo', logo);
        auth.UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        UserData userData = UserData(
            uid: cred.user!.uid,
            name: name,
            username: username,
            email: email,
            logo: imageUrl,
            description: description,
            sector: sector,
            address: address,
            website: website,
            certification: certification,
            phonenumber: phonenumber,
            password: password,
            confirmpassword: confirmpassword);

        userData.isSeller = false;

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(userData.toMapSupplier());

        await createRequestDocument(username, cred.user!.uid);

        resp = 'success';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }

  Future<void> createRequestDocument(
      String companyName, String sellerUid) async {
    try {
      bool collectionExists = await _firestore
          .collection("Requests")
          .doc()
          .get()
          .then((doc) => doc.exists);

      if (!collectionExists) {
        await _firestore.collection("Requests").doc();
      }

      Map<String, dynamic> requestData = {
        'companyName': companyName,
        'sellerUid': sellerUid,
      };

      await _firestore.collection('Requests').doc(companyName).set(requestData);
    } catch (err) {
      throw err;
    }
  }

  Future<String> loginUser(
      {
      // String? username,
      required String usernameOrEmail,
      required String password}) async {
    String res = 'Some error occured';

    try {
      if (usernameOrEmail.isNotEmpty && password.isNotEmpty) {
        if (usernameOrEmail.contains('@')) {
          await _auth.signInWithEmailAndPassword(
              email: usernameOrEmail, password: password);
          res = 'success';
        } else {
          QuerySnapshot query = await _firestore
              .collection('users')
              .where('username', isEqualTo: usernameOrEmail)
              .get();

          if (query.docs.isNotEmpty) {
            var userDoc = query.docs.first;
            String userEmail = userDoc['email'];

            await _auth.signInWithEmailAndPassword(
                email: userEmail, password: password);

            res = 'success';
          } else {
            res = 'User not found';
          }
        }
      } else {
        res = 'Please Enter All The Fields!';
      }
    } catch (err) {
      res = err.toString();
    }

    return res;
  }

  Future<UserData> getUserDetails() async {
    auth.User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return UserData.fromSnap(snap);
  }

  Future<String> uploadImageToStorage(String fileName, File file) async {
    firebase_storage.Reference ref =
        _storage.ref().child(fileName).child(uniqueFileName);
    firebase_storage.UploadTask uploadTask = ref.putFile(file);
    firebase_storage.TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> updateUserStatus(String sellerUid, bool value) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('uid', isEqualTo: sellerUid)
          .get();
      //     .then((value) {
      //   print('Got the user $value');
      // });

      if (query.docs.isNotEmpty) {
        var userDoc = query.docs.first;
        String documentId = userDoc.id;
        print('User id is : $documentId');
        await _firestore
            .collection('users')
            .doc(documentId)
            .update({'isSeller': value});
      }

      // DocumentSnapshot sellerDoc =
      //     await _firestore.collection('users').doc(sellerUid).get();

      // if (sellerDoc.exists) {
      //   await _firestore
      //       .collection('users')
      //       .doc(sellerUid)
      //       .update({'isSeller': value});
      // }
    } catch (err) {
      print('Error updating user: $err');
    }
  }

  Future<bool> getUserStatus(String sellerUid) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('uid', isEqualTo: sellerUid)
          .get();

      if (query.docs.isNotEmpty) {
        var userDoc = query.docs.first;
        // print('is seller : ${userDoc['isSeller'].toString()}');
        return userDoc['isSeller'] ?? false;
      } else {
        return false;
      }
    } catch (err) {
      print('Error getting user status: $err');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserData(String sellerUid) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('uid', isEqualTo: sellerUid)
          .get();

      if (query.docs.isNotEmpty) {
        var userDoc = query.docs.first;
        return userDoc.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (err) {
      print('Error getting user data: $err');
      return {};
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
