import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/kaligrafi/controllers/kaligrafi_controller.dart';

class KaligrafiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaligrafiController>(() => KaligrafiController());
  }
}