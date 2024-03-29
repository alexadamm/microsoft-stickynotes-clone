import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:sticky_notes_clone/config.dart';
import 'package:sticky_notes_clone/models/add_note_request.dart';
import 'package:sticky_notes_clone/models/auth_detail_model.dart';
import 'package:sticky_notes_clone/models/login_request_model.dart';
import 'package:sticky_notes_clone/models/login_response_model.dart';
import 'package:sticky_notes_clone/models/note_response.dart';
import 'package:sticky_notes_clone/models/notes_response_model.dart';
import 'package:sticky_notes_clone/models/referesh_auth_request.dart';
import 'package:sticky_notes_clone/models/refresh_auth_response.dart';
import 'package:sticky_notes_clone/models/register_request_model.dart';
import 'package:sticky_notes_clone/models/register_response_model.dart';
import 'package:sticky_notes_clone/services/shared_services.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.authAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 201) {
      LoginResponseModel loginResponse = loginResponseJson(response.body);
      await SharedService.setAuthDetails(loginResponse.data!);
      return true;
    }
    return false;
  }

  static Future<RegisterResponseModel> register(
      RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.regisAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return registerResponseModel(response.body);
  }

  static Future<NoteResponseModel> addNote(AddNoteRequest model) async {
    var loginDetails = await SharedService.authDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.notesAPI);

    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return noteResponseModel(response.body);
  }

  static Future<NotesResponseModel> getAllNotes() async {
    var loginDetails = await SharedService.authDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.notesAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 401) {
      await refreshAuthentication();
      return getAllNotes();
    }

    var notesBody = notesResponseModel(response.body);
    return notesBody;
  }

  static Future<NoteResponseModel> getNoteById(String id) async {
    var loginDetails = await SharedService.authDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    var noteBody = noteResponseModel(response.body);
    return noteBody;
  }

  static Future<NoteResponseModel> updateNoteById(
      String id, AddNoteRequest model) async {
    var loginDetails = await SharedService.authDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.put(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    return noteResponseModel(response.body);
  }

  static Future<NoteResponseModel> deleteNoteById(String id) async {
    var loginDetails = await SharedService.authDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    return noteResponseModel(response.body);
  }

  static Future<void> refreshAuthentication() async {
    var authDetails = await SharedService.authDetails();

    RefreshAuthRequestModel refreshAuth =
        RefreshAuthRequestModel(refreshToken: authDetails!.refreshToken!);

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.authAPI);

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(refreshAuth.toJson()),
    );

    if (response.statusCode == 200) {
      RefreshAuthResponseModel responseJson =
          refreshAuthResponseJson(response.body);
      AuthDetailModel authDetail = AuthDetailModel(
        accessToken: responseJson.data!.accessToken,
        refreshToken: authDetails.refreshToken,
      );
      await SharedService.setAuthDetails(authDetail);
    } else {
      await SharedService.signout();
    }
  }

  static Future<void> logout() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var loginDetails = await SharedService.authDetails();
    var refreshToken = loginDetails!.refreshToken;

    var url = Uri.http(dotenv.get('API_URL'), Config.authAPI);

    var response = await client.delete(
      url,
      headers: requestHeaders,
      body: '{"refreshToken": "$refreshToken"}',
    );

    debugPrint(response.toString());
  }
}
