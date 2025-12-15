abstract class BaseCourseModel {
  String? id;
  String title;
  bool isSynced;

  BaseCourseModel({
    this.id,
    required this.title,
    this.isSynced = true,
  });

  Map<String, dynamic> toJson();
}

abstract class BaseOrderedCourseModel extends BaseCourseModel {
  int order;

  BaseOrderedCourseModel({
    super.id,
    required super.title,
    required this.order,
    super.isSynced,
  });

  @override
  Map<String, dynamic> toJson() {
    return {'title': title, 'order': order};
  }
}
