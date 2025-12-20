import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/magang/controllers/magang_controller.dart';

class MagangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MagangController>(() => MagangController());
  }
}