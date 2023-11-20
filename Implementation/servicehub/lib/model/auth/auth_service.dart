import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:servicehub/model/auth/user_data.dart';

class AuthService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> logout() async {
    await _auth.signOut();
  }
}
