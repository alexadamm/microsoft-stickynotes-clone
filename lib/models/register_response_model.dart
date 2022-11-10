import 'dart:convert';

RegisterResponseModel registerResponseModel(String str) =>
  RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });
  late final bool isSuccess;
  late final String message;
  Data? data;
  List<String>? errors;
  
  RegisterResponseModel.fromJson(Map<String, dynamic> json){
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
    message = json['message'];
      data = Data.fromJson(json['data']);
    }
    if (json['errors']!= null) {
      errors = List.castFrom<dynamic, String>(json['errors']);
    }
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
    required this.addedUser,
  });
  late final AddedUser addedUser;
  
  Data.fromJson(Map<String, dynamic> json){
    addedUser = AddedUser.fromJson(json['addedUser']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['addedUser'] = addedUser.toJson();
    return _data;
  }
}

class AddedUser {
  AddedUser({
    required this.id,
    required this.username,
    required this.fullname,
  });
  late final String id;
  late final String username;
  late final String fullname;
  
  AddedUser.fromJson(Map<String, dynamic> json){
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['fullname'] = fullname;
    return _data;
  }
}