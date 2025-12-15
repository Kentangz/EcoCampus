import 'package:cloud_firestore/cloud_firestore.dart';

class NewsModel {
  String id;
  String title;
  String content;
  String imageUrl;
  bool isPublished;
  DateTime createdAt;
  DateTime updatedAt;
  bool isSynced;

  NewsModel({
    required this.id,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
    required this.isSynced,
  });

  factory NewsModel.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;

    return NewsModel(
      id: snap.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      isPublished: data['isPublished'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isSynced: data['isSynced'] ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "content": content,
        "imageUrl": imageUrl,
        "isPublished": isPublished,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "isSynced": isSynced,
      };
}
