import 'package:get/get.dart';
import '../controllers/dashboard_project_colaborasi_controllers.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
