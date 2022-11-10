import 'dart:convert';

import 'package:notes/models/note_detail_model.dart';

NoteResponseModel noteResponseModel(String str) =>
  NoteResponseModel.fromJson(json.decode(str));

class NoteResponseModel {
  NoteResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });
  late final bool isSuccess;
  late final String message;
  Data? data;
  List<String>? errors;
  
  NoteResponseModel.fromJson(Map<String, dynamic> json){
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
    this.addedNote,
    this.note
  });
  NoteDetailModel? addedNote;
  NoteDetailModel? note;

  
  Data.fromJson(Map<String, dynamic> json){
    if (json['addedNote'] != null) {
      addedNote = NoteDetailModel.fromJson(json['addedNote']);
    }
    if (json['note'] != null) {
      note = NoteDetailModel.fromJson(json['note']);
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['addedNote'] = addedNote!.toJson();
    _data['note'] = note!.toJson();
    return _data;
  }
}