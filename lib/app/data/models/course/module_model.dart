import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

class ModuleModel extends BaseOrderedCourseModel {
  ModuleModel({super.id, required super.title, required super.order});

  factory ModuleModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return ModuleModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
    );
  }
}
