import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';

class ApplicationState extends ChangeNotifier {
  bool isSwitched = false;
  bool isSellerMode = false;
  bool isSeller = false;
  int currentIndex = 0;
  UserData? _user;
  final AuthService _authService = AuthService();

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
