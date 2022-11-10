class NoteDetailModel {
  NoteDetailModel({
    required this.id,
    required this.owner,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String owner;
  late final String title;
  late final String content;
  late final String createdAt;
  late final String updatedAt;
  
  NoteDetailModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    owner = json['owner'];
    title = json['title'];
    content = json['content'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['owner'] = owner;
    _data['title'] = title;
    _data['content'] = content;
    _data['createdAt'] = createdAt;
    _data['updatedAt'] = updatedAt;
    return _data;
  }
}