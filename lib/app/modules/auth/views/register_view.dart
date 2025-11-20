import 'package:ecocampus/app/shared/widgets/shake_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

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
        suffixIcon: Icon(icon, color: Colors.grey),
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

                  const Text(
                    'Get Started',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'by creating a free account.',
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14,
                      color: textLight,
                    ),
                  ),

                  const SizedBox(height: 30),

                  ShakeWidget(
                    key: controller.nameShakeKey,
                    child: TextFormField(
                      controller: controller.fullNameC,
                      style: const TextStyle(fontFamily: fontFamily),
                      decoration: customInputDeco(
                        'Full name',
                        Icons.person_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  ShakeWidget(
                    key: controller.emailShakeKey,
                    child: TextFormField(
                      controller: controller.emailC,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: fontFamily),
                      decoration: customInputDeco(
                        'Valid email',
                        Icons.mail_outline,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!GetUtils.isEmail(value)) {
                          return 'Format email tidak valid';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

                  ShakeWidget(
                    key: controller.phoneShakeKey,
                    child: TextFormField(
                      controller: controller.phoneC,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(fontFamily: fontFamily),
                      decoration: customInputDeco(
                        'Phone number',
                        Icons.phone_android,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor HP tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 15),

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

                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      text: 'By checking the box you agree to our ',
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 10,
                        color: Colors.black54,
                      ),
                      children: [
                        TextSpan(
                          text: 'Terms',
                          style: TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Conditions.',
                          style: TextStyle(
                            color: primaryPurple,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
                            : controller.registerUser,
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
                                'Register',
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
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already a member? ',
                        style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Text(
                          'Log In',
                          style: TextStyle(
                            fontFamily: fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                ],
              ),
            ),
          ),
      ),
    );
  }
}
