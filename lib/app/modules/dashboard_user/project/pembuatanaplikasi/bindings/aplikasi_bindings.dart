import 'package:get/get.dart';
import '../controllers/aplikasi_controllers.dart';

class PembuatanAplikasiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PembuatanAplikasiController>(() => PembuatanAplikasiController());
  }
}
