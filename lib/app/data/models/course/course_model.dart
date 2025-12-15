import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

export 'module_model.dart';
export 'section_model.dart';
export 'material_model.dart';
export 'base_course_model.dart';
export 'quiz_model.dart';
export 'question_model.dart';

class CourseModel extends BaseCourseModel {
  String category;
  String icon;
  bool isActive;
  int totalModules;
  int totalQuizzes;

  String? imageUrl;
  String? techStackIcon;

  CourseModel({
    super.id,
    required super.title,
    this.category = 'akademik_karir',
    this.icon = 'school',
    this.isActive = true,
    this.totalModules = 0,
    this.totalQuizzes = 0,
    this.imageUrl,
    this.techStackIcon,
    this.createdAt,
    super.isSynced,
  });

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "category": category,
    "icon": icon,
    "isActive": isActive,
    "totalModules": totalModules,
    "totalQuizzes": totalQuizzes,
    "imageUrl": imageUrl,
    "techStackIcon": techStackIcon,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory CourseModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      category: data['category'] ?? 'akademik_karir',
      icon: data['icon'] ?? 'school',
      isActive: data['isActive'] ?? true,
      totalModules: data['totalModules'] ?? 0,
      totalQuizzes: data['totalQuizzes'] ?? 0,
      imageUrl: data['imageUrl'],
      techStackIcon: data['techStackIcon'],
      isSynced:
          !doc.metadata.hasPendingWrites &&
          (data['imageUrl'] == null ||
              data['imageUrl'] == '' ||
              data['imageUrl'].toString().startsWith('http')),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  DateTime? createdAt;
}
