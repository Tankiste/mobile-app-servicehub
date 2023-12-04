import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';

class ApplicationState extends ChangeNotifier {
  bool isSwitched = false;
  bool isSellerMode = false;
  bool isRequestSwitched = false;
  UserData? _user;
  final AuthService _authService = AuthService();

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    bool originalRequestSwitched = isRequestSwitched;

    try {
      UserData user = await _authService.getUserDetails();
      _user = user;
    } catch (error) {
    } finally {
      isRequestSwitched = originalRequestSwitched;
      notifyListeners();
    }
  }

  void toggleMode(bool isOn) {
    isSwitched = isOn;
    isSellerMode = isOn;
    notifyListeners();
  }

  void toggleRequestSwitch(bool isOn) {
    isRequestSwitched = isOn;
    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    _user = null;
    notifyListeners();
  }
}
