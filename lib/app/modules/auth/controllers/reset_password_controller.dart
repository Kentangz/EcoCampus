import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final passwordC = TextEditingController();
  final retypePasswordC = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final emailC = TextEditingController();
  String? oobCode;

  @override
  void onInit() {
    super.onInit();
    oobCode = Get.arguments as String?;
    if (oobCode == null) {
      NotificationHelper.showError(
        "Link Tidak Valid",
        "Link reset password tidak valid.",
      );
      Get.offAllNamed(Routes.LOGIN);
      return;
    }
    _verifyCode(oobCode!);
  }

  Future<void> _verifyCode(String code) async {
    try {
      isLoading(true);
      String email = await _authRepo.verifyPasswordResetCode(code);
      emailC.text = email;
    } catch (e) {
      NotificationHelper.showError("Link Error", e.toString());
      Get.offAllNamed(Routes.LOGIN);
    } finally {
      isLoading(false);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading(true);
      await _authRepo.confirmPasswordReset(oobCode!, passwordC.text);
      NotificationHelper.showSuccess(
        "Password Berhasil Diubah",
        "Silakan login dengan password baru Anda.",
      );
      _authRepo.navigateToLogin(force: true);
    } catch (e) {
      NotificationHelper.showError("Gagal", e.toString());
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    retypePasswordC.dispose();
    super.onClose();
  }
}
