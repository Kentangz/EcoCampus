import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas data analysis/controllers/data_analysis_controller.dart';

class DataAnalysisClassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataAnalysisClassController>(() => DataAnalysisClassController());
  }
}