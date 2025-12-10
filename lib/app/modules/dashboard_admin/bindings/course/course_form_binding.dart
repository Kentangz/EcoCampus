import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_form_controller.dart';

class CourseFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseFormController>(() => CourseFormController());
  }
}
