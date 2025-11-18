import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/exception_handler.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
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
    if (!formKey.currentState!.validate()) {
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
