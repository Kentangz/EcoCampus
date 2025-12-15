import 'package:get/get.dart';
import '../controllers/analisis_data_penjualan_controller.dart';

class ProjectAnalisisDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectAnalisisDataController>(() => ProjectAnalisisDataController());
  }
}