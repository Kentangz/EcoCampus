import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas python/controllers/python_controller.dart';

class PythonClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PythonClassController>(() => PythonClassController());
  }
}