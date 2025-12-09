import 'package:get/get.dart';
import '../controllers/kolaborasi_kampus_controller.dart';

class KolaborasiKampusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KolaborasiController>(() => KolaborasiController());
  }
}
