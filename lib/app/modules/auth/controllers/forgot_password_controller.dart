import 'dart:async';
import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/shared/utils/exception_handler.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final formKey = GlobalKey<FormState>();
  final emailShakeKey = GlobalKey<ShakeWidgetState>();
  final emailC = TextEditingController();
  final isLoading = false.obs;

  Timer? _timer;
  final waitTime = 30.obs;
  final canResend = true.obs;

  void startTimer() {
    canResend.value = false;
    waitTime.value = 30;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (waitTime.value > 0) {
        waitTime.value--;
      } else {
        _timer?.cancel();
        canResend.value = true;
      }
    });
  }

  Future<void> sendEmail() async {
    bool isValid = formKey.currentState!.validate();

    if (!isValid) {
      emailShakeKey.currentState?.shake();
      return;
    }

    if (isLoading.value || !canResend.value) return;

    try {
      isLoading(true);
      await _authRepo.sendPasswordResetEmail(emailC.text.trim());

      isLoading(false);

      NotificationHelper.showSuccess(
        "Link Terkirim",
        "Silakan periksa email Anda.",
      );

      startTimer();
    } catch (e) {
      isLoading(false);
      String errorMessage;
      if (e is FirebaseAuthException) {
        errorMessage = ExceptionHandler.handleAuthError(e);
      } else {
        errorMessage = 'Terjadi kesalahan. Coba lagi.';
      }
      NotificationHelper.showError("Gagal Mengirim", errorMessage);
      // emailShakeKey.currentState?.shake();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    emailC.dispose();
    super.onClose();
  }
}
