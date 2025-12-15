import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

class ModuleModel extends BaseOrderedCourseModel {
  String? imageUrl;
  bool isActive;

  ModuleModel({
    super.id,
    required super.title,
    required super.order,
    this.imageUrl,
    this.isActive = false,
    super.isSynced,
  });

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "order": order,
    "imageUrl": imageUrl,
    "isActive": isActive,
  };

  factory ModuleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ModuleModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      imageUrl: data['imageUrl'],
      isActive: data['isActive'] ?? false,
      isSynced:
          !doc.metadata.hasPendingWrites &&
          (data['imageUrl'] == null ||
              data['imageUrl'].toString().startsWith('http')),
    );
  }
}
