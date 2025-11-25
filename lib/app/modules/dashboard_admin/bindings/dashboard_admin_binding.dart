import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/overview_admin_controller.dart';

class DashboardAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController());
    Get.lazyPut<ActivityAdminController>(() => ActivityAdminController());
  }
}
