import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/dashboard_admin_controller.dart';

class DashboardAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController());
  }
}
