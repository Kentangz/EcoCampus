import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/controllers/email_verification_controller.dart';

class EmailVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailVerificationController>(() => EmailVerificationController());
  }
}
