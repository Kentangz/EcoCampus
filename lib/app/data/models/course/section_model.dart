import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

class SectionModel extends BaseOrderedCourseModel {
  SectionModel({
    super.id,
    required super.title,
    required super.order,
    super.isSynced,
  });

  factory SectionModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return SectionModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      isSynced: !doc.metadata.hasPendingWrites,
    );
  }
}
