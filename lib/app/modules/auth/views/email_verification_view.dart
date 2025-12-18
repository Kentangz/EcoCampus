import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ecocampus/app/modules/auth/controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF6C63FF);
    const Color textDark = Color(0xFF2D2D2D);
    const Color textLight = Colors.grey;
    const String fontFamily = 'Montserrat';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 45.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60),

              // Logo
              SizedBox(
                height: 150,
                child: Image.asset(
                  'assets/images/auth_logo_ecocampus.png',
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.email_outlined,
                      size: 120,
                      color: primaryPurple,
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Title
              const Text(
                'Verifikasi Email',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),

              const SizedBox(height: 15),

              // Description
              Text(
                'Kami telah mengirim link verifikasi ke:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 14,
                  color: textLight,
                ),
              ),

              const SizedBox(height: 10),

              // Email
              Text(
                controller.userEmail,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryPurple,
                ),
              ),

              const SizedBox(height: 20),

              // Instructions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryPurple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.info_outline, color: primaryPurple, size: 30),
                    SizedBox(height: 10),
                    Text(
                      'Silakan buka email Anda dan klik link verifikasi untuk mengaktifkan akun.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: fontFamily,
                        fontSize: 14,
                        color: textDark,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Check Verification Button
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
                    ),
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.checkVerificationStatus,
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
                            'Saya Sudah Verifikasi',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Resend Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: Obx(
                  () => OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: primaryPurple, width: 2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: controller.isSending.value
                        ? null
                        : controller.resendVerificationEmail,
                    child: controller.isSending.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: primaryPurple,
                              strokeWidth: 3,
                            ),
                          )
                        : const Text(
                            'Kirim Ulang Email',
                            style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Logout link
              TextButton(
                onPressed: controller.logout,
                child: const Text(
                  'Gunakan akun lain',
                  style: TextStyle(
                    fontFamily: fontFamily,
                    fontSize: 14,
                    color: textLight,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
