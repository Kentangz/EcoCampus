import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';
import 'package:ecocampus/app/data/models/course/module_model.dart';

export 'module_model.dart';
export 'section_model.dart';
export 'material_model.dart';
export 'base_course_model.dart';

class CourseModel extends BaseCourseModel {
  String category;
  String heroImage;
  bool isActive;
  int totalModules;

  List<ModuleModel>? temporaryModules;

  CourseModel({
    super.id,
    required super.title,
    this.category = 'akademik_karir',
    required this.heroImage,
    this.isActive = true,
    this.totalModules = 0,
    this.temporaryModules,
  });

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "category": category,
    "heroImage": heroImage,
    "isActive": isActive,
    "totalModules": totalModules,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory CourseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'akademik_karir',
      heroImage: data['heroImage'] ?? '',
      isActive: data['isActive'] ?? true,
      totalModules: data['totalModules'] ?? 0,
    );
  }
}
