import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/utils/exception_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> loginUser() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading(true);
      await _authRepo.loginUser(emailC.text.trim(), passwordC.text.trim());
    } catch (e) {
      String errorMessage;

      if (e is FirebaseAuthException) {
        errorMessage = ExceptionHandler.handleAuthError(e);
      } else {
        errorMessage = 'Terjadi kesalahan. Coba lagi.';
      }

      NotificationHelper.showError("Login Gagal", errorMessage);
    } finally {
      isLoading(false);
    }
  }
}
