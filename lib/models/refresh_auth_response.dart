import 'dart:convert';

RefreshAuthResponseModel refreshAuthResponseJson(String str) =>
    RefreshAuthResponseModel.fromJson(json.decode(str));

class RefreshAuthResponseModel {
  RefreshAuthResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });
  late final bool isSuccess;
  late final String message;
  Data? data;
  List<String>? errors;

  RefreshAuthResponseModel.fromJson(Map<String, dynamic> json) {
    isSuccess = json['isSuccess'];
    if (json['data'] != null) {
      message = json['message'];
      data = Data.fromJson(json['data']);
    }
    if (json['errors'] != null) {
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
    required this.accessToken,
  });
  late final String accessToken;

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['accessToken'] = accessToken;
    return _data;
  }
}
