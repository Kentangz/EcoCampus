import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
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
      String fullName = fullNameC.text.trim();
      String email = emailC.text.trim();
      String phone = phoneC.text.trim();
      String password = passwordC.text.trim();
      await _authRepo.createUser(email, password, fullName, phone);
    } catch (_) {
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
