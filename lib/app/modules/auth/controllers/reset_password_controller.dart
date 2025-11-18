import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final passwordC = TextEditingController();
  final retypePasswordC = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final emailC = TextEditingController();
  String? oobCode;
  bool _isCodeVerified = false;

  @override
  void onInit() {
    super.onInit();
    if (_isCodeVerified && emailC.text.isNotEmpty && oobCode != null) {
      return;
    }

    final args = Get.arguments as String?;
    if (args != null) {
      oobCode = args;
    }

    if (oobCode == null) {
      if (emailC.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          NotificationHelper.showError(
            "Link Tidak Valid",
            "Link reset password tidak valid.",
          );
          Future.delayed(const Duration(milliseconds: 500), () {
            _authRepo.navigateToLogin(force: true);
          });
        });
      }
      return;
    }

    if (!_isCodeVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _verifyCode(oobCode!);
      });
    }
  }

  Future<void> _verifyCode(String code) async {
    try {
      isLoading(true);
      String email = await _authRepo.verifyPasswordResetCode(code);
      emailC.text = email;
      _isCodeVerified = true;
    } catch (e) {
      NotificationHelper.showError("Link Error", e.toString());
      Future.delayed(const Duration(milliseconds: 500), () {
        _authRepo.navigateToLogin(force: true);
      });
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

    if (oobCode == null || !_isCodeVerified) {
      NotificationHelper.showError(
        "Link Tidak Valid",
        "Link reset password tidak valid atau sudah digunakan.",
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        _authRepo.navigateToLogin(force: true);
      });
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
