import 'package:get/get.dart';
import 'package:ecocampus/app/modules/dashboard_user/nonton film/controllers/nonton_film_controller.dart';

class NontonFilmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NontonFilmController>(() => NontonFilmController());
  }
}