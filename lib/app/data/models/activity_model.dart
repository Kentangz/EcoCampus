import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityModel {
  String? id;
  String title;
  String icon;
  String category; // seni_budaya, akademik_karir
  bool isActive; // true, false
  bool isSynced; 

  ActivityModel({
    this.id,
    required this.title,
    required this.icon,
    required this.category,
    required this.isActive,
    this.isSynced = true,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "icon": icon,
      "category": category,
      "isActive": isActive,
      "createdAt": FieldValue.serverTimestamp(),
    };
  }

  factory ActivityModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return ActivityModel(
      id: document.id,
      title: data["title"] ?? "",
      icon: data["icon"] ?? "help",
      category: data["category"] ?? "",
      isActive: data["isActive"] ?? false,
      isSynced: !document.metadata.hasPendingWrites,
    );
  }
}
