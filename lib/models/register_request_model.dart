class RegisterRequestModel {
  RegisterRequestModel({
    required this.fullname,
    required this.username,
    required this.password,
  });
  late final String fullname;
  late final String username;
  late final String password;
  
  RegisterRequestModel.fromJson(Map<String, dynamic> json){
    fullname = json['fullname'];
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullname'] = fullname;
    _data['username'] = username;
    _data['password'] = password;
    return _data;
  }
}