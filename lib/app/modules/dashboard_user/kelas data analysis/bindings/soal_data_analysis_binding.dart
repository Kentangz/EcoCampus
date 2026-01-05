import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kelas data analysis/controllers/soal_data_analysis_controller.dart';

class DataAnalysisQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DataAnalysisQuizController>(() => DataAnalysisQuizController());
  }
}