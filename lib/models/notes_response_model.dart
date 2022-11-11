import 'dart:convert';

import 'package:sticky_notes_clone/models/note_detail_model.dart';

NotesResponseModel notesResponseModel(String str) =>
    NotesResponseModel.fromJson(json.decode(str));

class NotesResponseModel {
  NotesResponseModel({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
  });
  late final bool isSuccess;
  late final String message;
  Data? data;
  List<String>? errors;

  NotesResponseModel.fromJson(Map<String, dynamic> json) {
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
    required this.notes,
  });
  late final List<NoteDetailModel> notes;

  Data.fromJson(Map<String, dynamic> json) {
    notes = List.from(json['notes'])
        .map((e) => NoteDetailModel.fromJson(e))
        .toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['notes'] = notes.map((e) => e.toJson()).toList();
    return _data;
  }
}
