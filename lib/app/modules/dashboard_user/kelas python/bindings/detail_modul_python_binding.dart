import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas python/controllers/detail_modul_python_controller.dart';

class PythonDetailModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PythonDetailModuleController>(() => PythonDetailModuleController());
  }
}