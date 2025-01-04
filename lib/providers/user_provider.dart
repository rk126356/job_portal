import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user/user_model.dart';

String globalUserId = "";

class UserProvider extends ChangeNotifier {
  late UserModel _userData;

  UserModel get userData => _userData;

  bool isButtonLoading = false;

  void setButtonLoading(bool data) {
    isButtonLoading = data;
    notifyListeners();
  }

  void setUserData(UserModel user) async {
    _userData = user;
    globalUserId = user.userId;
    await _saveUserDataToPrefs(user);
    notifyListeners();
  }

  void setUserDataTemp(UserModel user) async {
    _userData = user;

    notifyListeners();
  }

  Future<void> _saveUserDataToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = json.encode(user.toJson());
    await prefs.setString('userData', userDataJson);
  }

  Future<bool> loadUserLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataJson = prefs.getString('userData');
    if (userDataJson != null) {
      final userDataMap = json.decode(userDataJson);
      _userData = UserModel.fromJson(userDataMap);
      print(_userData.userType.toText());
      isProvider = _userData.userType == UserType.provider;
      isUser = _userData.userType == UserType.user;
      globalUserId = _userData.userId;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setTempUser(UserType type) {
    _userData = UserModel(
      name: 'John',
      userId: 'Doe',
      email: 'john.doe@example.com',
      phone: '123-456-7890',
      password: '11111111',
      createdAt: '2022-01-01 00:00:00',
      userType: type,
    );
    notifyListeners();
  }
}
