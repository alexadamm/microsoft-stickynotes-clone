import 'dart:convert';

AuthDetailModel authDetailJson(String str) =>
    AuthDetailModel.fromJson(json.decode(str));

class AuthDetailModel {
  AuthDetailModel({
    this.accessToken,
    this.refreshToken,
  });
  String? accessToken;
  String? refreshToken;

  AuthDetailModel.fromJson(Map<String, dynamic> json) {
    if (json['accessToken'] != null) {
      accessToken = json['accessToken'];
    }
    if (json['refreshToken'] != null) {
      refreshToken = json['refreshToken'];
    }
  }

  Map<String, dynamic> toJson() {
    final _authDetailModel = <String, dynamic>{};
    if (accessToken != null) {
      _authDetailModel['accessToken'] = accessToken;
    }
    if (refreshToken != null) {
      _authDetailModel['refreshToken'] = refreshToken;
    }
    return _authDetailModel;
  }
}
