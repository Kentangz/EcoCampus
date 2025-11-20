import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/controllers/reset_password_controller.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);
    const Color inputFillColor = Color(0xFFF0F0F0);
    const Color textDark = Color(0xFF2D2D2D);
    const Color textLight = Colors.grey;
    const String fontFamily = 'Montserrat';

    InputDecoration customInputDeco(String hint, IconData icon) {
      return InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: inputFillColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 150,
                    child: Image.asset(
                      'assets/images/auth_logo_ecocampus.png',
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.landscape_rounded,
                          size: 150,
                          color: primaryPurple,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Enter New Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 28,
                      fontWeight: FontWeight.normal,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14,
                      color: textLight,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ShakeWidget(
                    key: controller.passwordShakeKey,
                    child: Obx(
                      () => TextFormField(
                        controller: controller.passwordC,
                        obscureText: !controller.isPasswordVisible.value,
                        style: const TextStyle(fontFamily: fontFamily),
                        decoration:
                            customInputDeco(
                              'Strong Password',
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.lock_open_outlined
                                      : Icons.lock_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          if (value.length < 6) {
                            return 'Minimal 6 karakter';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  ShakeWidget(
                    key: controller.confirmPasswordShakeKey,
                    child: Obx(
                      () => TextFormField(
                        controller: controller.retypePasswordC,
                        obscureText: !controller.isPasswordVisible.value,
                        style: const TextStyle(fontFamily: fontFamily),
                        decoration:
                            customInputDeco(
                              'Repeat Your Password',
                              Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isPasswordVisible.value
                                      ? Icons.lock_open_outlined
                                      : Icons.lock_outline,
                                  color: Colors.grey,
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Konfirmasi password kosong';
                          }
                          if (value != controller.passwordC.text) {
                            return 'Password tidak sama';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(
                      () => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          shadowColor: primaryPurple.withValues(alpha: 0.4),
                        ),
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.resetPassword,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'Change Password',
                                style: TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}