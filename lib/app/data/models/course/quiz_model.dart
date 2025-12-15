import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecocampus/app/data/models/course/base_course_model.dart';

class QuizModel extends BaseOrderedCourseModel {
  String icon;
  List<String> rules;
  int totalQuestions;
  bool isActive;

  QuizModel({
    super.id,
    required super.title,
    required super.order,
    this.icon = 'code',
    this.rules = const [],
    this.totalQuestions = 0,
    this.isActive = true,
    super.isSynced,
  });

  @override
  Map<String, dynamic> toJson() => {
    "title": title,
    "order": order,
    "icon": icon,
    "rules": rules,
    "totalQuestions": totalQuestions,
    "isActive": isActive,
    "createdAt": FieldValue.serverTimestamp(),
  };

  factory QuizModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return QuizModel(
      id: doc.id,
      title: data['title'] ?? '',
      order: data['order'] ?? 0,
      icon: data['icon'] ?? 'code',
      rules: List<String>.from(data['rules'] ?? []),
      totalQuestions: data['totalQuestions'] ?? 0,
      isActive: data['isActive'] ?? true,
      isSynced: !doc.metadata.hasPendingWrites,
    );
  }
}
