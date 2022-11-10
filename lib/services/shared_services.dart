import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:notes/models/login_response_model.dart';
import 'package:notes/services/api_service.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    const secureStorage = FlutterSecureStorage();
    var cacheData =
      await secureStorage.read(key: "login_details");

    return (cacheData != null)? true : false;
  }

  static Future<LoginResponseModel?> loginDetails() async {
    const secureStorage = FlutterSecureStorage();
    var cacheData = await secureStorage.read(key: "login_details");

    if (cacheData != null) {
      return loginResponseJson(cacheData);
    }
    return null;
  }
  
  static Future<void> setLoginDetails(LoginResponseModel model) async {
    const secureStorage = FlutterSecureStorage();
    var dataJson = jsonEncode(model.toJson());
    await secureStorage.write(
      key: 'login_details',
      value: dataJson,
    );
  }

  static Future<void> logout(BuildContext context) async {
    await APIService.logout();
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: "login_details");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  static Future<void> signout() async {
    await APIService.logout();
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: "login_details");
  }
}