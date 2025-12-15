import 'package:get/get.dart';
import '../controllers/project_controller.dart';

class KolaborasiKampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(() => ProjectController());
  }
}
