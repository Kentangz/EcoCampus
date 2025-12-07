import 'package:cloud_firestore/cloud_firestore.dart';

class SectionModel {
  String? id;
  String title;
  int order;

  SectionModel({this.id, required this.title, required this.order});

  Map<String, dynamic> toJson() => {"title": title, "order": order};

  factory SectionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SectionModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
