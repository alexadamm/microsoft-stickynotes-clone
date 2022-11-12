import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sticky_notes_clone/models/auth_detail_model.dart';
import 'package:sticky_notes_clone/services/api_service.dart';

class SharedService {
  static Future<bool> isLoggedIn() async {
    const secureStorage = FlutterSecureStorage();
    var cacheData = await secureStorage.read(key: dotenv.get('AUTH_CACHE_KEY'));

    return (cacheData != null) ? true : false;
  }

  static Future<AuthDetailModel?> authDetails() async {
    const secureStorage = FlutterSecureStorage();
    var cacheData = await secureStorage.read(key: dotenv.get('AUTH_CACHE_KEY'));

    if (cacheData != null) {
      return authDetailJson(cacheData);
    }
    return null;
  }

  static Future<void> setAuthDetails(AuthDetailModel model) async {
    const secureStorage = FlutterSecureStorage();
    var dataJson = jsonEncode(model.toJson());
    await secureStorage.write(
      key: dotenv.get('AUTH_CACHE_KEY'),
      value: dataJson,
    );
  }

  static Future<void> logout(BuildContext context) async {
    await APIService.logout();
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: dotenv.get('AUTH_CACHE_KEY'));
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }

  static Future<void> signout() async {
    await APIService.logout();
    const secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: dotenv.get('AUTH_CACHE_KEY'));
  }
}
