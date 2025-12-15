import 'package:cloud_firestore/cloud_firestore.dart';

class UserCourseProgressModel {
  String courseId;
  String lastAccessedModuleId;

  List<String> completedModuleIds;

  List<String> completedSectionIds;

  UserCourseProgressModel({
    required this.courseId,
    this.lastAccessedModuleId = '',
    this.completedModuleIds = const [],
    this.completedSectionIds = const [],
  });

  Map<String, dynamic> toJson() => {
    "courseId": courseId,
    "lastAccessedModuleId": lastAccessedModuleId,
    "completedModuleIds": completedModuleIds,
    "completedSectionIds": completedSectionIds,
    "lastUpdated": FieldValue.serverTimestamp(),
  };

  factory UserCourseProgressModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return UserCourseProgressModel(
      courseId: data['courseId'] ?? '',
      lastAccessedModuleId: data['lastAccessedModuleId'] ?? '',
      completedModuleIds: List<String>.from(data['completedModuleIds'] ?? []),
      completedSectionIds: List<String>.from(data['completedSectionIds'] ?? []),
    );
  }

  bool isSectionUnlocked(int targetOrder, List<String> previousSectionIds) {
    if (targetOrder == 1) return true; 

    return true; 
  }
}
