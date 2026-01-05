import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas data analysis/controllers/modul_data_analysis_controller.dart';

class DataAnalysisModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataAnalysisModuleController>(() => DataAnalysisModuleController());
  }
}