class AddNoteRequest {
  AddNoteRequest({
    this.id,
    required this.title,
    required this.content,
  });
  String? id;
  late final String title;
  late final String content;
  
  AddNoteRequest.fromJson(Map<String, dynamic> json){
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['content'] = content;
    return _data;
  }
}