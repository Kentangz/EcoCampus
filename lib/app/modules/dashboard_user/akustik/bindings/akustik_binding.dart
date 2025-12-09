import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/akustik/controllers/akustik_controller.dart';

class AkustikBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AkustikController>(() => AkustikController());
  }
}