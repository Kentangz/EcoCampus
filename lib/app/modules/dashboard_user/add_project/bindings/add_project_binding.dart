import 'package:get/get.dart';
import '../controllers/add_project_controller.dart';

class AddProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddProjectController>(() => AddProjectController(), fenix: true);
  }
}
