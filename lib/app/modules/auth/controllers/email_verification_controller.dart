import 'package:ecocampus/app/data/repositories/authentication_repository.dart';
import 'package:ecocampus/app/routes/app_pages.dart';
import 'package:ecocampus/app/shared/utils/notification_helper.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  final _authRepo = AuthenticationRepository.instance;
  final isLoading = false.obs;
  final isSending = false.obs;

  String get userEmail => _authRepo.currentUser?.email ?? '';

  Future<void> resendVerificationEmail() async {
    if (isSending.value) return;

    try {
      isSending(true);
      await _authRepo.sendEmailVerification();
      NotificationHelper.showSuccess(
        "Email Terkirim",
        "Link verifikasi telah dikirim ke email Anda.",
      );
    } catch (e) {
      NotificationHelper.showError("Gagal", e.toString());
    } finally {
      isSending(false);
    }
  }

  Future<void> checkVerificationStatus() async {
    try {
      isLoading(true);

      // Reload user to get latest email verification status
      await _authRepo.currentUser?.reload();

      if (_authRepo.isEmailVerified) {
        // Move user data from PendingUsers to Users
        final uid = _authRepo.currentUser?.uid;
        if (uid != null) {
          await _authRepo.movePendingUserToVerified(uid);
        }

        NotificationHelper.showSuccess(
          "Email Terverifikasi",
          "Email Anda sudah terverifikasi!",
        );

        // Navigate to user dashboard (only users go through email verification)
        Get.offAllNamed(Routes.DASHBOARD_USER);
      } else {
        NotificationHelper.showInfo(
          "Belum Terverifikasi",
          "Email Anda belum terverifikasi. Silakan cek inbox email.",
        );
      }
    } catch (e) {
      NotificationHelper.showError("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _authRepo.logout();
  }
}
