import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class ApplicationState extends ChangeNotifier {
  bool isSwitched = false;
  bool isSellerMode = false;
  bool isSeller = false;
  bool isLiked = false;
  int currentIndex = 0;
  int totalLike = 0;
  // List<bool> isFavoriteList = [];
  UserData? _user;
  final AuthService _authService = AuthService();
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    try {
      UserData user = await _authService.getUserDetails();
      _user = user;
      isSellerMode = await _authService.getCurrentSellerMode();
      isSeller = await _authService.getCurrentUserStatus();
    } catch (error) {
    } finally {
      notifyListeners();
    }
  }

  Future<bool> checkLikeStatus(String serviceId) async {
    try {
      auth.User currentUser = _auth.currentUser!;
      DocumentSnapshot serviceSnapshot =
          await _firestore.collection('services').doc(serviceId).get();

      if (serviceSnapshot.exists) {
        List<String> likes = List<String>.from(serviceSnapshot['likes']);
        isLiked = likes.contains(currentUser.uid);

        notifyListeners();
        return isLiked;
      }
    } catch (err) {
      print('Error checking like status: $err');
    }
    return false;
  }

  Future<int> totalLikes(String serviceId) async {
    try {
      DocumentSnapshot serviceSnapshot =
          await _firestore.collection('services').doc(serviceId).get();

      if (serviceSnapshot.exists) {
        List<String> likes = List<String>.from(serviceSnapshot['likes']);
        totalLike = likes.length;

        notifyListeners();
        return totalLike;
      }
    } catch (err) {
      print('Error getting the number of likes: $err');
    }
    return 0;
  }

  Future<double> calculateAverageRating(String serviceId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('reviews')
          .where('service Id', isEqualTo: serviceId)
          .get();

      if (snapshot.docs.isEmpty) {
        return 0.0;
      }

      double totalRating = 0;
      for (var doc in snapshot.docs) {
        totalRating += (doc['rating'] as int).toDouble();
      }

      double averageRating = totalRating / snapshot.docs.length;
      return averageRating;
    } catch (err) {
      print('Error calculating average rating: $err');
      return 0.0;
    }
  }

  // void likeButton(int index) {
  //   isFavoriteList[index] = !isFavoriteList[index];
  //   notifyListeners();
  // }

  void switchMode() {
    isSellerMode = !isSellerMode;
    if (isSellerMode) {
      currentIndex = 3;
    } else {
      currentIndex = 4;
    }
    notifyListeners();
  }

  // void updateIndex(bool isSeller, int newIndex) {
  //   isSellerMode = isSeller;
  //   currentIndex = newIndex;
  //   notifyListeners();
  // }

  void toggleMode(bool isOn) {
    isSwitched = isOn;
    // isSellerMode = isOn;
    notifyListeners();
  }

  // void toggleRequestSwitch(bool isOn) {
  //   isRequestSwitched = isOn;
  //   notifyListeners();
  // }

  Future<void> logoutUser(BuildContext context) async {
    _user = null;
    notifyListeners();
  }
}
