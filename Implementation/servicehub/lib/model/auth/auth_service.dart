import 'dart:io';
// import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:servicehub/firebase_services.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseServices _services = FirebaseServices();

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

        userData.status = "Offline";
        userData.logo = "";
        userData.isSeller = false;
        userData.sellerMode = false;
        userData.date = Timestamp.now();

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

        userData.status = "Offline";
        userData.isSeller = false;
        userData.sellerMode = false;
        userData.date = Timestamp.now();

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

  Future<String> upgradeToSeller({
    required String name,
    required String username,
    required File logo,
    required String description,
    required String sector,
    required String address,
    String? website,
    String? certification,
    required int phonenumber,
  }) async {
    String resp = 'Some Error occured';
    auth.User currentUser = _auth.currentUser!;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
    String imageUrl = await uploadImageToStorage('Logo', logo);

    Map<String, dynamic> sellerData = {
      'CEO name': name,
      'username': username,
      'logoLink': imageUrl,
      'description': description,
      'sector': sector,
      'address': address,
      'website': website,
      'certification': certification,
      'phonenumber': phonenumber,
    };

    try {
      await userDocRef.update(sellerData);

      await createRequestDocument(username, currentUser.uid);

      resp = 'success';

      print('Fields successfully added for supplier !');
    } catch (e) {
      resp = e.toString();
      print('Error during update : $e');
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
        'isSeller': false,
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

  Future<void> updateStatus(String status) async {
    auth.User currentUser = _auth.currentUser!;
    await _firestore.collection('users').doc(currentUser.uid).update({
      'status': status,
    });
  }

  Future<UserData> getUserDetails() async {
    auth.User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    print("New id: ${currentUser.uid}");
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

  Future<void> updateRequestStatus(String companyName, bool value) async {
    try {
      DocumentSnapshot sellerDoc =
          await _firestore.collection('Requests').doc(companyName).get();

      if (sellerDoc.exists) {
        await _firestore
            .collection('Requests')
            .doc(companyName)
            .update({'isSeller': value});
      }
    } catch (err) {
      print('Error updating user: $err');
    }
  }

  Future<UserData?> getClient(String clientId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(clientId).get();

      if (snapshot.exists) {
        return UserData(
            uid: clientId,
            username: snapshot['username'],
            email: snapshot['email'],
            logo: snapshot['logoLink']);
      } else {
        return null;
      }
    } catch (e) {
      print('Error when fetching user: $e');
      return null;
    }
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

  Future<void> updateSellerMode(String sellerUid, bool value) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('users')
          .where('uid', isEqualTo: sellerUid)
          .get();

      if (query.docs.isNotEmpty) {
        var userDoc = query.docs.first;
        String documentId = userDoc.id;
        print('User id is : $documentId');
        await _firestore
            .collection('users')
            .doc(documentId)
            .update({'sellerMode': value});
      }
    } catch (err) {
      print('Error updating user: $err');
    }
  }

  Future<bool> getCurrentUserStatus() async {
    try {
      auth.User currentUser = _auth.currentUser!;
      if (currentUser != null) {
        QuerySnapshot query = await _firestore
            .collection('users')
            .where('uid', isEqualTo: currentUser.uid.toString())
            .get();

        if (query.docs.isNotEmpty) {
          var userDoc = query.docs.first;
          bool isSeller = userDoc['isSeller'];
          // print(
          //     'The seller ${currentUser.toString()} status is : ${isSeller.toString()}');
          return isSeller;
        }
      }
      return false;
    } catch (err) {
      print('Error getting current user status: $err');
      return false;
    }
  }

  Future<bool> getCurrentSellerMode() async {
    try {
      auth.User currentUser = _auth.currentUser!;

      if (currentUser != null) {
        QuerySnapshot query = await _firestore
            .collection('users')
            .where('uid', isEqualTo: currentUser.uid.toString())
            .get();

        if (query.docs.isNotEmpty) {
          var userDoc = query.docs.first;
          bool sellerMode = userDoc['sellerMode'];
          // print('The seller status is : ${sellerMode.toString()}');
          return sellerMode;
        }
      }
      return false;
    } catch (err) {
      print('Error getting current user status: $err');
      return false;
    }
  }

  Future<bool> getUserStatus(String companyName) async {
    try {
      DocumentSnapshot sellerDoc =
          await _firestore.collection('Requests').doc(companyName).get();

      if (sellerDoc.exists) {
        bool isSeller = sellerDoc['isSeller'];
        return isSeller;
      }
      return false;
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

  Future<String> updateAccount({
    String? username,
    File? logo,
  }) async {
    String resp = 'Some Error occured';
    auth.User currentUser = _auth.currentUser!;
    DocumentReference userDocRef =
        FirebaseFirestore.instance.collection('users').doc(currentUser.uid);

    DocumentSnapshot userSnapshot = await userDocRef.get();
    bool isSeller = userSnapshot.get('isSeller');

    // String? currentUsername = userSnapshot.get('username');
    // String? currentCompanyName = userSnapshot.get('company name');
    String? currentLogo = userSnapshot.get('logoLink');

    String? updatedUsername;
    if (username != null && username.isNotEmpty) {
      updatedUsername = username;
    } else {
      updatedUsername = isSeller
          ? userSnapshot.get('company name')
          : userSnapshot.get('username');
    }

    String? updatedLogo =
        logo != null ? await uploadImageToStorage('Logo', logo) : currentLogo;

    Map<String, dynamic> updateData = {
      'username': updatedUsername,
      'logoLink': updatedLogo,
    };

    try {
      await userDocRef.update(updateData);
      resp = 'success';
      print('Fields successfully updated !');
    } catch (e) {
      resp = e.toString();
      print('Error during update : $e');
    }

    return resp;
  }

  Future<String> resetPassword(String email) async {
    String resp = 'Some Error occured';
    try {
      await _auth.sendPasswordResetEmail(email: email);
      resp = 'success';
      print('Password reset email sent to $email');
    } catch (e) {
      resp = e.toString();
      print('Failed to send password reset email: $e');
      // Gérer les erreurs ici
    }
    return resp;
  }

  Stream<QuerySnapshot> getTotalClientsStream() {
    return _firestore
        .collection('users')
        .where('isSeller', isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getTotalSuppliersStream() {
    return _firestore
        .collection('users')
        .where('isSeller', isEqualTo: true)
        .snapshots();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
// Map<String, dynamic> updateData = {};

    // if (username != null) {
    //   if (isSeller) {
    //     updateData['username'] = username;
    //   } else {
    //     updateData['company name'] = username;
    //   }
    // } else if (userData.username != null) {
    //   if (isSeller) {
    //     updateData['username'] = userData.username;
    //   } else {
    //     updateData['company name'] = userData.username;
    //   }
    // }

    // if (logo != null) {
    //   String imageUrl = await uploadImageToStorage('Logo', logo);
    //   updateData['logoLink'] = imageUrl;
    // } else if (userData.logo != null) {
    //   updateData['logoLink'] = userData.logo;
    // }

    // try {
    //   await userDocRef.update(updateData);
    //   resp = 'success';
    //   print('Fields successfully updated !');
    // } catch (e) {
    //   resp = e.toString();
    //   print('Error during update : $e');
    // }