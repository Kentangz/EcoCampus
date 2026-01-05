import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas python/controllers/soal_python_controller.dart';

class PythonQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PythonQuizController>(() => PythonQuizController());
  }
}