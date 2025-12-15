import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/question_form_controller.dart';

class QuestionFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuestionFormController>(() => QuestionFormController());
  }
}
