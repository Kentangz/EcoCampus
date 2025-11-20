import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final passwordShakeKey = GlobalKey<ShakeWidgetState>();
  final confirmPasswordShakeKey = GlobalKey<ShakeWidgetState>();
  late final TextEditingController passwordC;
  late final TextEditingController retypePasswordC;
  late final TextEditingController emailC;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  String? oobCode;
  bool _isCodeVerified = false;

  @override
  void onInit() {
    super.onInit();
    passwordC = TextEditingController();
    retypePasswordC = TextEditingController();
    emailC = TextEditingController();

    final args = Get.arguments as String?;
    if (args != null) oobCode = args;

    if (oobCode == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (isClosed) return;
        NotificationHelper.showError(
          "Link Tidak Valid",
          "Link reset password tidak valid.",
        );
        Future.delayed(const Duration(seconds: 2), () {
          _authRepo.navigateToLogin(force: true);
        });
      });
    } else if (!_isCodeVerified) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _verifyCode(oobCode!);
      });
    }
  }

  Future<void> _verifyCode(String code) async {
    if (isClosed) return;
    try {
      isLoading(true);
      String email = await _authRepo.verifyPasswordResetCode(code);

      if (!isClosed) {
        emailC.text = email;
        _isCodeVerified = true;
      }
    } catch (e) {
      if (isClosed) return;
      NotificationHelper.showError("Link Error", e.toString());
      Future.delayed(const Duration(milliseconds: 500), () {
        _authRepo.navigateToLogin(force: true);
      });
    } finally {
      if (!isClosed) isLoading(false);
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    if (isClosed) return;

    if (!formKey.currentState!.validate()) {
      if (passwordC.text.isEmpty || passwordC.text.length < 6) {
        passwordShakeKey.currentState?.shake();
      }
      if (retypePasswordC.text.isEmpty ||
          retypePasswordC.text != passwordC.text) {
        confirmPasswordShakeKey.currentState?.shake();
      }
      return;
    }

    if (oobCode == null || !_isCodeVerified) {
      NotificationHelper.showError(
        "Link Tidak Valid",
        "Link reset password tidak valid.",
      );
      return;
    }

    try {
      isLoading(true);
      await _authRepo.confirmPasswordReset(oobCode!, passwordC.text);

      if (isClosed) return;

      NotificationHelper.showSuccess(
        "Password Berhasil Diubah",
        "Silakan login dengan password baru Anda.",
      );

      await Future.delayed(const Duration(seconds: 1));

      _authRepo.navigateToLogin(force: true);
    } catch (e) {
      if (isClosed) return;
      NotificationHelper.showError("Gagal", e.toString());
    } finally {
      if (!isClosed) isLoading(false);
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
