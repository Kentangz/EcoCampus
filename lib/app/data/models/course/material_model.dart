import 'package:cloud_firestore/cloud_firestore.dart';

enum MaterialType { text, video, quiz }

class MaterialModel {
  String? id;
  String title;
  MaterialType type;
  String content; 
  int order; 

  MaterialModel({
    this.id,
    required this.title,
    required this.type,
    required this.content,
    required this.order,
  });

  Map<String, dynamic> toJson() => {
    "title": title,
    "type": type.name, 
    "content": content,
    "order": order,
  };

  factory MaterialModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MaterialModel(
      id: doc.id,
      title: data['title'] ?? '',
      type: MaterialType.values.firstWhere(
        (e) => e.name == (data['type'] ?? 'text'),
        orElse: () => MaterialType.text,
      ),
      content: data['content'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
