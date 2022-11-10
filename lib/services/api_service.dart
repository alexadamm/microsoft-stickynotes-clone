import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:notes/config.dart';
import 'package:notes/models/add_note_request.dart';
import 'package:notes/models/login_request_model.dart';
import 'package:notes/models/login_response_model.dart';
import 'package:notes/models/note_response.dart';
import 'package:notes/models/notes_response_model.dart';
import 'package:notes/models/register_request_model.dart';
import 'package:notes/models/register_response_model.dart';
import 'package:notes/services/shared_services.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(LoginRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.authAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    if (response.statusCode == 201) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));
      return true;
    }
    return false;
  }

  static Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.regisAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    return registerResponseModel(response.body);
  }

  static Future<NoteResponseModel> addNote(AddNoteRequest model) async {

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.notesAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    return noteResponseModel(response.body);
  }

  static Future<NotesResponseModel> getAllNotes() async {

    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), Config.notesAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    var notesBody = notesResponseModel(response.body);
    return notesBody;
  }

  static Future<NoteResponseModel> getNoteById(String id) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    var noteBody = noteResponseModel(response.body);
    return noteBody;
  }

  static Future<NoteResponseModel> updateNoteById(String id, AddNoteRequest model) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    return noteResponseModel(response.body);
  }

  static Future<NoteResponseModel> deleteNoteById(String id) async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginDetails!.data!.accessToken}'
    };

    var url = Uri.http(dotenv.get('API_URL'), "${Config.notesAPI}/$id");

    var response = await client.delete(
      url,
      headers: requestHeaders,
    );

    return noteResponseModel(response.body);
  }

  static Future<void> logout() async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var loginDetails = await SharedService.loginDetails();
    var refreshToken = loginDetails!.data!.refreshToken;

    var url = Uri.http(dotenv.get('API_URL'), Config.authAPI);

    var response = await client.delete(
      url,
      headers: requestHeaders,
      body: '{"refreshToken": "$refreshToken"}',
    );

    debugPrint(response.toString());
  }
}