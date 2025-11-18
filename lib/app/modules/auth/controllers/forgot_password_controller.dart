import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/exception_handler.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final emailC = TextEditingController();
  final isLoading = false.obs;

  Future<void> sendEmail() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading(true);
      await _authRepo.sendPasswordResetEmail(emailC.text.trim());

      isLoading(false);

      NotificationHelper.showSuccess(
        "Link Terkirim",
        "Silakan periksa email Anda (termasuk folder spam).",
      );

      await Future.delayed(const Duration(seconds: 2));

      Get.back();
    } catch (e) {
      isLoading(false);
      String errorMessage;
      if (e is FirebaseAuthException) {
        errorMessage = ExceptionHandler.handleAuthError(e);
      } else {
        errorMessage = 'Terjadi kesalahan. Coba lagi.';
      }
      NotificationHelper.showError("Gagal Mengirim", errorMessage);
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }
}
