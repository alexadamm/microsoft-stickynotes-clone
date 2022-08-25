class Note {
  int? id;
  String title;
  String content;
  int updatedAt = DateTime.now().millisecondsSinceEpoch;

  Note({this.id, this.title = "Title", this.content = "Content"});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) {
      data['id'] = id;
    }
    data['title'] = title;
    data['content'] = content;
    data['updated_at'] = updatedAt;
    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
    }.toString();
  }
}
