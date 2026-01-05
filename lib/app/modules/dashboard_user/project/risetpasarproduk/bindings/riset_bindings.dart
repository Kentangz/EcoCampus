import 'package:get/get.dart';
import '../controllers/riset_controller.dart';

class RisetPasarProdukBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RisetPasarProdukController>(
      () => RisetPasarProdukController(),
      fenix: true,
    );
  }
}
