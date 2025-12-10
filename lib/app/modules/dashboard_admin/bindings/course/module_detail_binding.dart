import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/module_detail_controller.dart';

class ModuleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModuleDetailController>(() => ModuleDetailController());
  }
}
