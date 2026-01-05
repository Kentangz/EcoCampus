import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas data analysis/controllers/detail_modul_data_analysis_controller.dart';

class DataAnalysisDetailModuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataAnalysisDetailModuleController>(() => DataAnalysisDetailModuleController());
  }
}