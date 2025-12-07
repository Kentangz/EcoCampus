import 'package:cloud_firestore/cloud_firestore.dart';

class ModuleModel {
  String? id;
  String title;
  int order;

  ModuleModel({this.id, required this.title, required this.order});

  Map<String, dynamic> toJson() => {"title": title, "order": order};

  factory ModuleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ModuleModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
