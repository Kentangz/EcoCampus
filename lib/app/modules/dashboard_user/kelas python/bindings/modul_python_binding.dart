import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas python/controllers/modul_python_controller.dart';

class PythonModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PythonModuleController>(() => PythonModuleController());
  }
}