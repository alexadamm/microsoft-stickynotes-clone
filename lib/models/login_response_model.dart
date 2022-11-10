import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
  LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.isSuccess,
    required this.message,
    required this.data,
    this.errors,
  });
  late final bool isSuccess;
  late final String message;
  Data? data;
  List<String>? errors;
  
  LoginResponseModel.fromJson(Map<String, dynamic> json){
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      message = json['message'];
      data = Data.fromJson(json['data']);
    }
    if (json['errors']!= null) {
      errors = List.castFrom<dynamic, String>(json['errors']);
    };
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['isSuccess'] = isSuccess;
    _data['message'] = message;
    _data['data'] = data!.toJson();
    _data['errors'] = errors;
    return _data;
  }
}

class Data {
  Data({
    required this.accessToken,
    required this.refreshToken,
  });
  late final String accessToken;
  late final String refreshToken;
  
  Data.fromJson(Map<String, dynamic> json){
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['accessToken'] = accessToken;
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}