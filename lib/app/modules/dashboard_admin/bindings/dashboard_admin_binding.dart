import 'package:ecocampus/app/data/repositories/activity_repository.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/activity_admin_controller.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_admin/controllers/dashboard_admin_controller.dart';

class DashboardAdminBinding extends Bindings {
  @override
  void dependencies() {

    Get.lazyPut<ActivityRepository>(() => ActivityRepository());

    Get.lazyPut<DashboardAdminController>(() => DashboardAdminController());
    Get.lazyPut<ActivityAdminController>(() => ActivityAdminController());
  }
}
