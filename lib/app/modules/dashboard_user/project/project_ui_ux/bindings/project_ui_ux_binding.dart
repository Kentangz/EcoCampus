import 'package:get/get.dart';
import '../controllers/project_ui_ux_controller.dart';

class ProjectUiUxBinding extends Bindings {
  @override
  void dependencies() {
    // fenix true agar bisa dire-create saat sudah di-dispose
    Get.lazyPut<ProjectUiUxController>(() => ProjectUiUxController(), fenix: true);
  }
}
