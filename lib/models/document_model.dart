import 'dart:convert';

class DocumentModel {
  final String title;
  final String uid;
  final String id;
  final DateTime createdAt;
  final List content;
  DocumentModel({
    required this.title,
    required this.uid,
    required this.id,
    required this.createdAt,
    required this.content,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'uid': uid,
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'content': content,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      title: map['title'] ?? '',
      uid: map['uid'] ?? '',
      id: map['_id'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      content: List.from(map['content']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentModel.fromJson(String source) => DocumentModel.fromMap(json.decode(source));
}
