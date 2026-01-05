import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/magang/controllers/detail_magang_controller.dart';

class DetailMagangBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailMagangController>(() =>DetailMagangController());
  }
}