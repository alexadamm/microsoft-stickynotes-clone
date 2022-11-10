import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  void signup(String username, String password, String fullname, String email) async {
    Uri url = Uri.parse("localhost:3001/users");

    var response = await http.post(
      url,
      body: json.encode({
        "email": email,
        "username": username,
        "password": password,
        "fullname": fullname,
      }),
    );

    print(json.decode(response.body));
  }
}