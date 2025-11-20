import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/exception_handler.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final nameShakeKey = GlobalKey<ShakeWidgetState>();
  final emailShakeKey = GlobalKey<ShakeWidgetState>();
  final phoneShakeKey = GlobalKey<ShakeWidgetState>();
  final passwordShakeKey = GlobalKey<ShakeWidgetState>();
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final phoneC = TextEditingController();
  final passwordC = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> registerUser() async {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      if (fullNameC.text.isEmpty) nameShakeKey.currentState?.shake();

      if (emailC.text.isEmpty || !GetUtils.isEmail(emailC.text)) {
        emailShakeKey.currentState?.shake();
      }

      if (phoneC.text.isEmpty) phoneShakeKey.currentState?.shake();

      if (passwordC.text.isEmpty || passwordC.text.length < 6) {
        passwordShakeKey.currentState?.shake();
      }
      return;
    }

    try {
      isLoading(true);
      await _authRepo.createUser(
        emailC.text.trim(),
        passwordC.text.trim(),
        fullNameC.text.trim(),
        phoneC.text.trim(),
      );
      NotificationHelper.showSuccess("Berhasil", "Akun berhasil dibuat");
      Get.back();
    } catch (e) {
      String errorMessage;
      if (e is FirebaseAuthException) {
        errorMessage = ExceptionHandler.handleAuthError(e);
      } else {
        errorMessage = 'Terjadi kesalahan. Coba lagi.';
      }
      NotificationHelper.showError("Registrasi Gagal", errorMessage);
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    fullNameC.dispose();
    emailC.dispose();
    phoneC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
