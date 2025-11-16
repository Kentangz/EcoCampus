import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
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
      String email = emailC.text.trim();
      String password = passwordC.text.trim();
      await _authRepo.loginUser(email, password);
    } catch (_) {
    } finally {
      isLoading(false);
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }
}
