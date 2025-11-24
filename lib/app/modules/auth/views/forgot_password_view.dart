import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/controllers/forgot_password_controller.dart';
import 'package:ecocampus/app/shared/widgets/shake_widget.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);
    const Color inputFillColor = Color(0xFFF0F0F0);
    const Color textDark = Color(0xFF2D2D2D);
    const Color textLight = Colors.grey;
    const String fontFamily = 'Montserrat';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 45.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                  const SizedBox(height: 0),

                  const Text(
                    'Enter Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.normal,
                      color: textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter email address to verify your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 14,
                      color: textLight,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  ShakeWidget(
                    key: controller.emailShakeKey,
                    child: TextFormField(
                      controller: controller.emailC,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(fontFamily: fontFamily),
                      decoration: InputDecoration(
                        hintText: 'Your email',
                        hintStyle: const TextStyle(color: Colors.grey),
                        filled: true,
                        fillColor: inputFillColor,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        suffixIcon: const Icon(
                          Icons.mail_outline,
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
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
                  const SizedBox(height: 30),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: Obx(() {
                      final bool isButtonDisabled =
                          controller.isLoading.value ||
                          !controller.canResend.value;

                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          disabledBackgroundColor: primaryPurple.withValues(
                            alpha: 0.3,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: isButtonDisabled ? 0 : 2,
                          shadowColor: primaryPurple.withValues(alpha: 0.4),
                        ),
                        onPressed: isButtonDisabled ? null : controller.sendEmail,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text(
                                !controller.canResend.value
                                    ? 'Wait ${controller.waitTime.value}s'
                                    : 'Send verification',
                                style: const TextStyle(
                                  fontFamily: fontFamily,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      );
                    }),
                  ),
                  const SizedBox(height: 40),

                  Column(
                    children: [
                      const Text(
                        "Didn't receive any email?",
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),

                      Obx(() {
                        if (controller.canResend.value) {
                          return GestureDetector(
                            onTap: controller
                                .sendEmail,
                            child: const Text(
                              "Resend Code",
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                          );
                        } else {
                          String seconds = controller.waitTime.value
                              .toString()
                              .padLeft(2, '0');
                          return Text(
                            "Request new in 00:${seconds}s",
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          );
                        }
                      }),
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
