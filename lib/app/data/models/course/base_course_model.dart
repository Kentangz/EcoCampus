abstract class BaseCourseModel {
  String? id;
  String title;

  BaseCourseModel({this.id, required this.title});

  Map<String, dynamic> toJson();
}

abstract class BaseOrderedCourseModel extends BaseCourseModel {
  int order;

  BaseOrderedCourseModel({super.id, required super.title, required this.order});

  @override
  Map<String, dynamic> toJson() {
    return {'title': title, 'order': order};
  }
}
