import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/course_admin_controller.dart';

class CourseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CourseAdminController>(() => CourseAdminController());
  }
}
