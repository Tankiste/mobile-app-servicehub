import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';

class ApplicationState extends ChangeNotifier {
  bool isSwitched = false;
  bool isSellerMode = false;
  UserData? _user;
  final AuthService _authService = AuthService();

  UserData? get getUser => _user;

  Future<void> refreshUser() async {
    UserData user = await _authService.getUserDetails();
    _user = user;
    notifyListeners();
  }

  void toggleMode(bool isOn) {
    isSwitched = isOn;
    isSellerMode = isOn;
    notifyListeners();
  }

  Future<void> logoutUser(BuildContext context) async {
    _user = null;
    notifyListeners();
  }
}
