import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/course/material_builder_controller.dart';

class MaterialBuilderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialBuilderController>(() => MaterialBuilderController());
  }
}
